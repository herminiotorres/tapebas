defmodule Tapebas.Events.Talk do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "talks" do
    field :speaker, :string
    field :title, :string
    field :slug, :string
    field :description, :string
    field :type, Ecto.Enum, values: [:keynote, :general, :beginner, :advanced], default: :general

    belongs_to :event, Tapebas.Events.Event, foreign_key: :event_id

    has_many :questions, Tapebas.Events.Question, on_delete: :delete_all

    has_many :likes, Tapebas.Events.Like, on_delete: :delete_all

    timestamps()
  end

  @fields ~w(title slug description type speaker event_id)a
  @required_fields ~w(title slug type speaker event_id)a

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, @fields)
    |> build_slug()
    |> validate_required(@required_fields)
    |> validate_length(:title, min: 6)
    |> validate_length(:speaker, min: 2)
    |> foreign_key_constraint(:event_id)
  end

  # def like_changeset(talk, attrs) do
  #   talk
  #   |> cast(attrs, @fields)
  #   |> cast_embed(:likes, required: true)
  # end

  defp build_slug(%{changes: %{title: title}} = changeset) do
    if title do
      put_change(changeset, :slug, Slug.slugify(title))
    else
      changeset
    end
  end

  defp build_slug(changeset), do: changeset
end
