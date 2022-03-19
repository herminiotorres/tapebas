defmodule Tapebas.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :message, :text, null: false
      add :question_id, references(:questions, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:comments, [:question_id])
    create index(:comments, [:user_id])
  end
end
