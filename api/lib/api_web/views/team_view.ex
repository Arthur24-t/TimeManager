defmodule ApiWeb.TeamView do
  use ApiWeb, :view
  alias ApiWeb.TeamView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{id: team.id, name: team.name}
  end

  def render("users.json", %{users: users}) do
    %{data: render_many(users, ApiWeb.UserView, "user.json")}
  end
end
