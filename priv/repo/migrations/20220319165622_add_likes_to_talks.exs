defmodule Tapebas.Repo.Migrations.AddLikesToTalks do
  use Ecto.Migration

  def change do
    alter table(:talks) do
      add :likes, {:array, :map}, default: []
    end
  end
end
