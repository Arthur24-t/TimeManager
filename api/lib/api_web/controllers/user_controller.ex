defmodule ApiWeb.UserController do
  use ApiWeb, :controller
  alias Api.Accounts
  alias Api.Accounts.User

  action_fallback(ApiWeb.FallbackController)

  def index(conn, %{"email" => email, "username" => username})
  when not is_nil(email) and email != "" and not is_nil(username) and username != "" do
    case Accounts.list_users_by_email_username(email, username) do
      nil -> send_resp(conn, :not_found, "No user found")
      user -> render(conn, "show.json", user: user)
    end
  end


  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end


  def create(conn, %{"user" => user_params}) do
    current_user = conn.assigns[:current_user]

    params_without_role =
      cond do
        current_user.role not in ["superadmin"] -> Map.delete(user_params, "role")
        current_user.role not in ["admin", "superadmin"] -> Map.delete(user_params, "team")
        true -> user_params
      end

    with {:ok, %User{} = user} <- Accounts.create_user(params_without_role) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    else
      _ -> conn |> put_status(:unprocessable_entity) |> render("error.json")
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

    if current_user.role in ["admin", "superadmin"] do
      case Accounts.remove_team_from_user(user_id, team_id) do
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


  defp allowed_to_access?(current_user, user) do
    current_user.role in ["superadmin"] or
      (current_user.role in ["admin"] and current_user.team == user.team) or
      current_user.id == user.id
  end
end
