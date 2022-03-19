defmodule Tapebas.Repo.Migrations.CreateTalks do
  use Ecto.Migration

  def change do
    create table(:talks) do
      add :title, :string, null: false
      add :type, :string, null: false
      add :speaker, :string, null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:talks, [:event_id])
  end
end
