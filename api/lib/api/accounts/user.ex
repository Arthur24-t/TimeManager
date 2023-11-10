defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :username, :email, :role]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :role, :string, default: "user"
    many_to_many :teams, Api.Accounts.Team, join_through: "users_teams",on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password,:role])
    |> cast_assoc(:teams)
    |> validate_format(:email, ~r/^[\w-.]+@([\w-]+.)+[\w-]{2,4}$/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
