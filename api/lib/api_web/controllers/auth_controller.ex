defmodule ApiWeb.AuthController do
  use ApiWeb, :controller
  alias Api.Repo
  alias Api.Accounts
  alias Api.Auth.Guardian

  def register(conn, %{"user" => user_params}) do
    case Api.Accounts.create_user(user_params) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:created)
        |> json(%{user: user, token: token})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Api.Accounts.authenticate(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> json(%{user: user, token: token})
      :error ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: "Invalid email or password")
    end
  end
end
