defmodule ApiWeb.UserControllerTest do
  use ApiWeb.ConnCase, async: true
  alias Api.Repo
  alias Api.Accounts
  alias ApiWeb.Router.Helpers, as: Routes
  alias Api.Auth.Guardian
  setup do
    # Create a user using the Accounts context directly
    user_params = %{
      username: "admin",
      email: "admin@admin.com",
      password: "1234",
      role: "superadmin"

    }

    # Assuming Accounts.create_user/1 is a function you have defined in your context
    # that handles user creation.
    {:ok, user} = Accounts.create_user(user_params)
    user = Accounts.get_user!(user.id) |> Repo.preload(:teams)
    csrf_token = Plug.CSRFProtection.get_csrf_token()
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{csrf_token: csrf_token})

    {:ok, jwt: jwt, user: user, csrf_token: csrf_token}
  end

  # Helper function to authenticate the connection
  defp authenticate_conn(conn, jwt) do
    put_req_header(conn, "authorization", "Bearer #{jwt}")
  end

  test "creates a user successfully", %{conn: conn, jwt: jwt, csrf_token: csrf_token} do
    conn = authenticate_conn(conn, jwt)
    user_params = %{name: "New User", email: "newuser@example.com", password: "pass1234",role: "user"}
    conn = put_resp_cookie(conn, "csrf_token", csrf_token, http_only: true)

    conn = post(conn, Routes.user_path(conn, :create), user: user_params)

    assert resp = json_response(conn, 201)
    assert resp["user"]["id"]
    assert resp["user"]["name"] == "New User"
  end

  test "lists all users", %{conn: conn, jwt: jwt, csrf_token: csrf_token} do
    # Authenticate the connection first
    conn = authenticate_conn(conn, jwt)

    # Then, if needed, set the cookie
    conn = put_resp_cookie(conn, "csrf_token", csrf_token, http_only: true)

    # Now, make the GET request
    conn = get(conn, Routes.user_path(conn, :index))

    # Process the response
    response = json_response(conn, 200)
    IO.inspect(response, label: "Response JSON")

    assert is_list(response["users"])
    assert length(response["users"]) == 1
  end


  test "shows user details when authorized", %{conn: conn, jwt: jwt, user: user,  csrf_token: csrf_token} do
    conn = authenticate_conn(conn, jwt)
    conn = put_resp_cookie(conn, "csrf_token", csrf_token, http_only: true)

    conn = get(conn, Routes.user_path(conn, :show, user.id))


    assert json_response(conn, 200)["user"]
  end

  test "deletes a user successfully when authorized", %{conn: conn, jwt: jwt, user: user,  csrf_token: csrf_token} do
    conn = authenticate_conn(conn, jwt)
    conn = put_resp_cookie(conn, "csrf_token", csrf_token, http_only: true)
    conn = delete(conn, Routes.user_path(conn, :delete, user.id))


    assert response(conn, 204)
  end
end
