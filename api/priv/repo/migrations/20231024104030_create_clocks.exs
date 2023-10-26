defmodule Api.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :time, :utc_datetime
      add :status, :boolean, default: false, null: false
      add :user, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:clocks, [:user])
  end
end
