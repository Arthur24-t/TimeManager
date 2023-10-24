defmodule Todolist.MyApp.UserTest do
  use Todolist.DataCase

  alias Todolist.MyApp.User

  describe "users" do
    alias Todolist.MyApp.User.User

    @valid_attrs %{username: "some username", email: "some email"}
    @update_attrs %{username: "some updated username", email: "some updated email"}
    @invalid_attrs %{username: nil, email: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> User.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert User.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert User.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = User.create_user(@valid_attrs)
      assert user.username == "some username"
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = User.update_user(user, @update_attrs)
      assert user.username == "some updated username"
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_user(user, @invalid_attrs)
      assert user == User.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = User.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> User.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = User.change_user(user)
    end
  end
end
