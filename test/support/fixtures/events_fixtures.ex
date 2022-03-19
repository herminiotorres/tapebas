defmodule Tapebas.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tapebas.Events` context.
  """

  @doc """
  Generate a event description.
  """
  def event_description, do: "some description#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique event title.
  """
  def unique_event_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a random talk type.
  """
  def random_talk_type, do: Enum.random(~w(keynote general beginner advanced))

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    %{id: user_id} = Tapebas.AccountsFixtures.user_fixture()
    title = unique_event_title()

    {:ok, event} =
      attrs
      |> Enum.into(%{
        title: title,
        slug: Slug.slugify(title),
        description: event_description(),
        user_id: user_id
      })
      |> Tapebas.Events.create_event()

    event
  end

  @doc """
  Generate a talk.
  """
  def talk_fixture(attrs \\ %{}) do
    event = event_fixture()

    {:ok, talk} =
      attrs
      |> Enum.into(%{
        speaker: "some speaker",
        title: "some title",
        type: random_talk_type(),
        event_id: event.id
      })
      |> Tapebas.Events.create_talk()

    talk
  end

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    talk = talk_fixture()
    %{id: user_id} = Tapebas.AccountsFixtures.user_fixture()

    {:ok, question} =
      attrs
      |> Enum.into(%{
        answered: Enum.random([true, false]),
        title: "some title",
        user_id: user_id,
        talk_id: talk.id
      })
      |> Tapebas.Events.create_question()

    question
  end
end
