defmodule ApiWeb.UserController do
  use ApiWeb, :controller
  require Logger
  alias Api.Accounts
  alias Api.Accounts.User
  alias Api.Repo

  action_fallback(ApiWeb.FallbackController)

  def index(conn, %{"email" => email, "username" => username})
      when not is_nil(email) and email != "" and not is_nil(username) and username != "" do
    case Accounts.list_users_by_email_username(email, username) do
      nil -> send_resp(conn, :not_found, "No user found")
      user -> render(conn, "show.json", user: user)
    end
  end

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    if current_user.role in ["admin", "superadmin"] do
      users = Accounts.list_users()
      render(conn, "index.json", users: users)
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def create(conn, %{"user" => user_params}) do
    current_user = conn.assigns[:current_user]

    if current_user.role in ["superadmin"] do
      case Accounts.create_user(user_params) do
        {:ok, user} ->
          conn = fetch_session(conn)

          conn
          |> put_status(:created)
          |> json(%{user: user})

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)
      end

    else
      conn |> put_status(:forbidden) |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(id)

    if allowed_to_access?(current_user, user) do
      render(conn, "show.json", user: user)
    else
      conn |> put_status(:forbidden) |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = conn.assigns[:current_user]

    case current_user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: "Current user not found")

      _ ->
        user = Accounts.get_user!(id)

        if allowed_to_access?(current_user, user) do
          with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
            render(conn, "show.json", user: user)
          else
            _ -> conn |> put_status(:unprocessable_entity) |> render("error.json")
          end
        else
          conn |> put_status(:forbidden) |> render(ApiWeb.ErrorView, "403.json")
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(id)

    if allowed_to_access?(current_user, user) do
      case Accounts.delete_user(user) do
        {:ok, %User{}} ->
          send_resp(conn, :no_content, "")
        {:error, reason} ->
          send_resp(conn, :unprocessable_entity, "error: #{reason}")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def add_team_to_user(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    current_user = conn.assigns[:current_user]

    if current_user.role in ["admin", "superadmin"] do
      case Accounts.add_team_to_user(user_id, team_id) do
        {:ok, user} ->
          conn
          |> put_status(:ok)
          |> render("show.json", user: user)

        {:error, _reason} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def remove_team_from_user(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(user_id)

    if allowed_to_access?(current_user, user) do
      case Accounts.remove_team_from_user(user_id, team_id) do
        {:ok, %User{}} ->
          send_resp(conn, :no_content, "")
        {:error, reason} ->
          send_resp(conn, :unprocessable_entity, "error: #{reason}")
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
