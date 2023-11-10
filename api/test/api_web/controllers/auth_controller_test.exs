defmodule ApiWeb.AuthControllerTest do
  use ApiWeb.ConnCase

  alias Api.Accounts
  alias ApiWeb.Router.Helpers, as: Routes

  setup do
    {:ok, _user} = Accounts.create_user(@valid_user_params["user"])
    :ok
  end

  @valid_user_params %{
    "user" => %{
      "username" => "newuser",
      "email" => "newuser@example.com",
      "password" => "securepassword",
      "role" => "user"
    }
  }

  @valid_login_params %{
    "email" => "newuser@example.com",
    "password" => "securepassword"
  }


    test "registers a new user", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :register), @valid_user_params)
      assert json_response(conn, 201)["user"]
    end

    test "logs in a user", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), @valid_login_params)
      assert json_response(conn, 200)["jwt"]
    end
  end
