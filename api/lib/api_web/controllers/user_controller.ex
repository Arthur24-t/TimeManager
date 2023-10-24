defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Schemas
  alias Api.Schemas.User

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    user = Schemas.list_users()
    render(conn, "index.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Schemas.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Schemas.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Schemas.get_user!(id)

    with {:ok, %User{} = user} <- Schemas.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Schemas.get_user!(id)

    with {:ok, %User{}} <- Schemas.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
