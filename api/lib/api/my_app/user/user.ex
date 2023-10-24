defmodule Todolist.MyApp.User.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    timestamps()
  end

  @required_fields ~w(username email)
  @optional_fields ~w()

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/@/)
  end
end
