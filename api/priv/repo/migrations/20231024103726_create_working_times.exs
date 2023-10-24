defmodule Api.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:users)

      timestamps()
    end

  end
end
