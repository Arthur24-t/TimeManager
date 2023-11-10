defmodule ApiWeb.WorkingTimeController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.WorkingTime
  alias Api.Repo

  action_fallback(ApiWeb.FallbackController)

  def index(conn, %{"userID" => user_id, "start" => start_date, "end" => end_date})
      when is_binary(user_id) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(user_id)

    if allowed_to_access?(current_user, user) do
      working_times =
        Accounts.find_working_times_by_user_and_date_range(user_id, start_date, end_date)

      render(conn, "index.json", working_times: working_times)
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def show(conn, %{"userID" => user_id, "id" => id}) when is_binary(user_id) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(user_id)

    if allowed_to_access?(current_user, user) do
      with %WorkingTime{} = working_time <- Accounts.get_working_time(user_id, id) do
        render(conn, "show.json", working_time: working_time)
      else
        nil ->
          conn
          |> send_resp(:not_found, "Working Time not found")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def create(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(user_id)

    if allowed_to_access?(current_user, user) do
      case Accounts.create_working_time(Map.merge(%{"user" => user_id}, working_time_params)) do
        {:ok, %WorkingTime{} = working_time} ->
          conn
          |> put_status(:created)
          |> render("show.json", working_time: working_time)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)

        _ ->
          conn
          |> send_resp(:internal_server_error, "Internal Server Error")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    current_user = conn.assigns[:current_user]
    working_time = Accounts.get_working_time!(id)
    user = Accounts.get_user!(working_time.user)

    if allowed_to_access?(current_user, user) do
      case Accounts.get_working_time!(id) do
        %WorkingTime{} = working_time ->
          case Accounts.update_working_time(working_time, working_time_params) do
            {:ok, %WorkingTime{} = updated_working_time} ->
              render(conn, "show.json", working_time: updated_working_time)

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)

            _ ->
              conn
              |> send_resp(:internal_server_error, "Internal Server Error")
          end

        nil ->
          conn
          |> send_resp(:not_found, "Working Time not found")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    working_time = Accounts.get_working_time!(id)
    user = Accounts.get_user!(working_time.user)

    if allowed_to_access?(current_user, user) do
      case Accounts.get_working_time!(id) do
        %WorkingTime{} = working_time ->
          case Accounts.delete_working_time(working_time) do
            {:ok, %WorkingTime{}} ->
              send_resp(conn, :no_content, "")

            {:error, reason} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render("error.json", error: reason)
          end

        nil ->
          conn
          |> send_resp(:not_found, "Working Time not found")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  defp allowed_to_access?(current_user, user) do
    current_user.role in ["superadmin"] or
      (current_user.role in ["admin"] and in_same_team?(current_user, user)) or
      current_user.id == user.id
  end

  def in_same_team?(user1, user2) do
    # Préchargez les équipes pour chaque utilisateur si elles ne sont pas déjà préchargées
    user1 = Repo.preload(user1, :teams)
    user2 = Repo.preload(user2, :teams)

    # Récupérez les ID des équipes pour les deux utilisateurs
    team_ids1 = Enum.map(user1.teams, & &1.id)
    team_ids2 = Enum.map(user2.teams, & &1.id)

    # Vérifiez si il y a un chevauchement dans les ID des équipes
    Enum.any?(team_ids1, fn id -> id in team_ids2 end)
  end
end
