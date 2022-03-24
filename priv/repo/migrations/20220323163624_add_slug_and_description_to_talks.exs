defmodule Tapebas.Repo.Migrations.AddSlugAndDescriptionToTalks do
  use Ecto.Migration

  def change do
    alter table(:talks) do
      add :slug, :citext
      add :description, :text
    end

    create index(:talks, [:slug])
  end
end
