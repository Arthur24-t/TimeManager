defmodule Api.ApiWeb.UserControllerTest do
  use Api.ConnCase

  test "creates a new user" do
    user_params = %{user: %{username: "testuser", email: "test@example.com"}}
    conn = post(conn(), api_user_path(conn, :create), user_params)

    assert conn.status == 201
    assert json_response(conn, 201)["username"] == "testuser"
  end
end
