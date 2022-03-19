defmodule Tapebas.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string, null: false
      add :answered, :boolean, default: false, null: false
      add :talk_id, references(:talks, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:questions, [:talk_id])
    create index(:questions, [:user_id])
  end
end
