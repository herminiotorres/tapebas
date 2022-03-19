defmodule Tapebas.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tapebas.Accounts.User

  schema "events" do
    field :title, :string
    field :slug, :string
    field :description, :string
    belongs_to :user, User, foreign_key: :user_id

    timestamps()
  end

  @fields ~w(title slug description user_id)a
  @required_fields ~w(title slug)a

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @fields)
    |> build_slug()
    |> validate_required(@required_fields)
    |> validate_length(:title, min: 10, max: 145)
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
