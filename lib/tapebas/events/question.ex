defmodule Tapebas.Events.Question do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :answered, :boolean, default: false
    field :title, :string

    belongs_to :user, Tapebas.Accounts.User, foreign_key: :user_id
    belongs_to :talk, Tapebas.Events.Talk, foreign_key: :talk_id

    has_many :comments, Tapebas.Events.Comment, on_delete: :delete_all

    timestamps()
  end

  @fields ~w(title answered talk_id user_id)a
  @required_fields ~w(title talk_id user_id)a

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, min: 10)
    |> foreign_key_constraint(:talk_id)
    |> foreign_key_constraint(:user_id)
  end
end
