defmodule Tapebas.Events.Like do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Tapebas.Accounts.User
  alias Tapebas.Events.Talk

  schema "likes" do
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :talk, Talk, foreign_key: :talk_id

    timestamps()
  end

  @fields ~w(talk_id user_id)a
  @required_fields ~w(talk_id user_id)a

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:talk_id)
    |> unique_constraint(@fields)
  end
end
