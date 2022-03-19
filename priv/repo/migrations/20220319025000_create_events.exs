defmodule Tapebas.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :citext, null: false
      add :slug, :string, null: false
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:events, [:slug])
    create unique_index(:events, [:title])
    create index(:events, [:user_id])
  end
end
