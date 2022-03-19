defmodule Tapebas.EventsTest do
  use Tapebas.DataCase

  import Tapebas.EventsFixtures

  alias Tapebas.Events
  alias Tapebas.Events.Event
  alias Tapebas.Events.Talk

  describe "events" do
    @invalid_attrs %{slug: nil, title: nil, description: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      user = Tapebas.AccountsFixtures.user_fixture()
      valid_attrs = %{title: "some title", description: "some description", user_id: user.id}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.slug == "some-title"
      assert event.title == "some title"
      assert event.description == "some description"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{slug: "some updated title", title: "some updated title"}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.slug == "some-updated-title"
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  describe "talks" do
    @invalid_attrs %{speaker: nil, title: nil, type: nil}

    test "list_talks/0 returns all talks" do
      talk = talk_fixture()
      assert Events.list_talks() == [talk]
    end

    test "get_talk!/1 returns the talk with given id" do
      talk = talk_fixture()
      assert Events.get_talk!(talk.id) == talk
    end

    test "create_talk/1 with valid data creates a talk" do
      event = Tapebas.EventsFixtures.event_fixture()

      valid_attrs = %{
        speaker: "some speaker",
        title: "some title",
        type: "general",
        event_id: event.id
      }

      assert {:ok, %Talk{} = talk} = Events.create_talk(valid_attrs)
      assert talk.speaker == "some speaker"
      assert talk.title == "some title"
      assert talk.type == :general
    end

    test "create_talk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_talk(@invalid_attrs)
    end

    test "update_talk/2 with valid data updates the talk" do
      talk = talk_fixture()

      update_attrs = %{
        speaker: "some updated speaker",
        title: "some updated title",
        type: "general"
      }

      assert {:ok, %Talk{} = talk} = Events.update_talk(talk, update_attrs)
      assert talk.speaker == "some updated speaker"
      assert talk.title == "some updated title"
      assert talk.type == :general
    end

    test "update_talk/2 with invalid data returns error changeset" do
      talk = talk_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_talk(talk, @invalid_attrs)
      assert talk == Events.get_talk!(talk.id)
    end

    test "delete_talk/1 deletes the talk" do
      talk = talk_fixture()
      assert {:ok, %Talk{}} = Events.delete_talk(talk)
      assert_raise Ecto.NoResultsError, fn -> Events.get_talk!(talk.id) end
    end

    test "change_talk/1 returns a talk changeset" do
      talk = talk_fixture()
      assert %Ecto.Changeset{} = Events.change_talk(talk)
    end
  end
end
