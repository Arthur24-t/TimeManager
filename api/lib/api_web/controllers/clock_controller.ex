defmodule ApiWeb.ClockController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Clock
  alias Api.Repo

  action_fallback ApiWeb.FallbackController

  def show(conn, %{"userID" => user_id}) when is_binary(user_id) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(user_id)


    if allowed_to_access?(current_user, user) do

    case Accounts.get_user(user_id) do
      nil ->
        conn
        |> send_resp(:not_found, "User not found")
      _user ->
        clocks = Accounts.list_user_clocks(user_id)
        render(conn, "index.json", clocks: clocks)
    end
  else
    conn
    |> put_status(:forbidden)
    |> render(ApiWeb.ErrorView, "403.json")
  end
end

  def create(conn, %{"userID" => user_id, "clock" => clock_params}) when is_binary(user_id) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user(user_id)

    if allowed_to_access?(current_user, user) do
    case Accounts.get_user(user_id) do
      nil ->
        conn
        |> send_resp(:not_found, "User not found")
      _user ->
        case Accounts.create_user_clock(user_id, clock_params) do
          {:ok, %Clock{} = clock} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
            |> render("show.json", clock: clock)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)
        end
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
