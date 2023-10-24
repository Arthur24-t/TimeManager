defmodule Todolist.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :user_id, :integer
      add :time, :utc_datetime
      add :status, :boolean, default: false, null: false

      timestamps()
    end

  end
end
