defmodule ApiWeb.UserController do
  use ApiWeb, :controller
  require Logger  # <-- Ajoutez cette ligne
  alias Api.Accounts
  alias Api.Accounts.User

  action_fallback(ApiWeb.FallbackController)

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.json", users: users)
  # end

  def index(conn, params) do
    case params do
      %{"email" => email, "username" => username} when email != "" and username != "" ->
        user = Accounts.list_users_by_email_username(email, username)

        case user do
          nil ->S
            send_resp(conn, :not_found, "No user found")
          _ ->
            render(conn, "show.json", user: user)
        end
      _ ->
        send_resp(conn, :bad_request, "Missing email and/or username")
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      nil ->
        send_resp(conn, :not_found, "User not found")
      %User{} = user ->
        case Accounts.delete_user(user) do
          {:ok, %User{}} ->
            send_resp(conn, :no_content, "")
          {:error, reason} ->
            send_resp(conn, :unprocessable_entity, "error: #{reason}")
        end
    end
  end

end
