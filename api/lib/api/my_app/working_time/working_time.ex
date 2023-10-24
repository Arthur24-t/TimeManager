defmodule Todolist.MyApp.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, MyApp.User

    timestamps()
  end

  @required_fields ~w(start end user_id)
  @optional_fields ~w()

  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:start, :end, :user_id])
  end
end
