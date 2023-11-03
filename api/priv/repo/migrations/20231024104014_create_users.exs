defmodule Api.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :email, :string
      add :password, :string
      add :role, :string, default: "user"
      add :team, references(:teams, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
