defmodule Api.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :user, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:working_times, [:user])
  end
end
