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
end
