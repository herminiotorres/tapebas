defmodule Tapebas.Events.Event do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :title, :string
    field :slug, :string
    field :description, :string

    belongs_to :user, Tapebas.Accounts.User, foreign_key: :user_id
    has_many :talks, Tapebas.Events.Talk, on_delete: :delete_all

    timestamps()
  end

  @fields ~w(title slug description user_id)a
  @required_fields ~w(title slug user_id)a

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @fields)
    |> build_slug()
    |> validate_required(@required_fields)
    |> validate_length(:title, min: 6)
    |> unique_constraint(:slug)
    |> unique_constraint(:title)
    |> foreign_key_constraint(:user_id)
  end

  defp build_slug(%{changes: %{title: title}} = changeset) do
    if title do
      put_change(changeset, :slug, Slug.slugify(title))
    else
      changeset
    end
  end

  defp build_slug(changeset), do: changeset
end
