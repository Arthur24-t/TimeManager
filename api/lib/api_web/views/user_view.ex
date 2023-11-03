defmodule ApiWeb.UserView do
  use ApiWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "userteam.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "userteam.json")}
  end

  def render("users.json", %{users: users}) do
    %{data: render_many(users, ApiWeb.UserView, "userteam.json")}
  end

  def render("userteam.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      teams: render_many(user.teams, ApiWeb.TeamView, "team.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
    }
  end
end
