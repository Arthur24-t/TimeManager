defmodule ApiWeb.AuthController do
  use ApiWeb, :controller
  alias Api.Repo
  alias Api.Accounts
  alias Api.Auth.Guardian

  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn = fetch_session(conn)
        csrf_token = Plug.CSRFProtection.get_csrf_token()
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{csrf_token: csrf_token})

        conn
        |> put_resp_cookie("csrf_token", csrf_token, http_only: true)
        |> put_status(:created)
        |> json(%{user: user, token: jwt})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        conn = fetch_session(conn)
        csrf_token = Plug.CSRFProtection.get_csrf_token()
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{csrf_token: csrf_token})

        conn
        |> put_resp_cookie("csrf_token", csrf_token, http_only: true)
        |> json(%{user: user, token: jwt})

      {:error, "User not found"} ->
        conn
        |> put_status(:not_found)
        |> render(ApiWeb.ErrorView, "404.json", reason: "User not found")

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render(ApiWeb.ErrorView, "401.json", reason: "Invalid email or password")
    end
  end
end
