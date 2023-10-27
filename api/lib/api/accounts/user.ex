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
    field :role, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password,:role])
    |> validate_format(:email, ~r/^[\w-.]+@([\w-]+.)+[\w-]{2,4}$/)
  end
end
