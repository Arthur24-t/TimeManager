defmodule Api.Accounts.UserTeam do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @derive {Jason.Encoder, only: [:user_id, :team_id]}
  schema "users_teams" do
    belongs_to :user, Api.Accounts.User, type: :binary_id
    belongs_to :team, Api.Accounts.Team, type: :binary_id

  end

   def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
  end
end
