defmodule Tapebas.Events.Comment do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :message, :string

    belongs_to :user, Tapebas.Accounts.User, foreign_key: :user_id
    belongs_to :question, Tapebas.Events.Question, foreign_key: :question_id

    timestamps()
  end

  @fields ~w(message question_id user_id)a
  @required_fields ~w(message)a

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:message, min: 10)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
  end
end
