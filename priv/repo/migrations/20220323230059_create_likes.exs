defmodule Tapebas.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users)
      add :talk_id, references(:talks)

      timestamps()
    end

    create unique_index(:likes, [:user_id, :talk_id])
  end
end
