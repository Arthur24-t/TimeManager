defmodule ApiWeb.TeamController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Team

  action_fallback(ApiWeb.FallbackController)

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    if current_user.role in ["superadmin"] do
      teams = Accounts.list_teams()
      render(conn, "index.json", teams: teams)
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def create(conn, %{"team" => team_params}) do
    current_user = conn.assigns[:current_user]

    if current_user.role in ["superadmin"]  do
      case Accounts.create_team(team_params) do
        {:ok, %Team{} = team} ->
          conn
          |> put_status(:created)
          |> render("show.json", team: team)

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

  def update(conn, %{"team_id" => id, "team" => team_params}) do
    current_user = conn.assigns[:current_user]

    if current_user.role in ["superadmin"]  do
      case Accounts.get_team!(id) do
        %Team{} = team ->
          case Accounts.update_team(team, team_params) do
            {:ok, %Team{} = updated_team} ->
              render(conn, "show.json", team: updated_team)

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
          |> send_resp(:not_found, "Team Time not found")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def delete(conn, %{"team_id" => id}) do
    current_user = conn.assigns[:current_user]

    if current_user.role in ["superadmin"]  do
      case Accounts.get_team!(id) do
        %Team{} = team ->
          case Accounts.delete_team(team) do
            {:ok, %Team{}} ->
              send_resp(conn, :no_content, "")

            {:error, reason} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render("error.json", error: reason)
          end

        nil ->
          conn
          |> send_resp(:not_found, "Team Time not found")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(ApiWeb.ErrorView, "403.json")
    end
  end

  def get_users_of_team(conn, %{"team_id" => team_id}) do

    case Accounts.get_team_with_users(team_id) do
      nil ->
        conn
        |> send_resp(404, "Team not found")
      team ->
        render(conn, "users.json", users: team.users)
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
