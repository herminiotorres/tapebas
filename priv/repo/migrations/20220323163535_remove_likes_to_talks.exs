defmodule Tapebas.Repo.Migrations.RemoveLikesToTalks do
  use Ecto.Migration

  def change do
    alter table(:talks) do
      remove :likes
    end
  end
end
