defmodule Tapebas.Events.Like do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    belongs_to :user, Tapebas.Accounts.User, foreign_key: :user_id
  end

  @fields ~w(user_id)a

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, @fields)
    |> validate_required(:user_id)
  end
end
