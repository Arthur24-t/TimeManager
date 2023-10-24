defmodule Todolist.MyApp.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :time, :utc_datetime
    field :status, :boolean
    belongs_to :user, MyApp.User

    timestamps()
  end

  @required_fields ~w(time status user_id)
  @optional_fields ~w()

  def changeset(clock, attrs) do
    clock
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:time, :status, :user_id])
  end
end
