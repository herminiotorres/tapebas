defmodule Tapebas.Events.Talk do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "talks" do
    field :speaker, :string
    field :title, :string
    field :type, Ecto.Enum, values: [:keynote, :general, :beginner, :advanced], default: :general

    belongs_to :event, Tapebas.Events.Event, foreign_key: :event_id

    timestamps()
  end

  @fields ~w(title type speaker event_id)a
  @required_fields ~w(title type speaker event_id)a

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, min: 10)
    |> validate_length(:speaker, min: 2)
    |> foreign_key_constraint(:user_id)
  end
end
