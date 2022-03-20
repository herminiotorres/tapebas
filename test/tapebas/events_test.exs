defmodule Tapebas.EventsTest do
  use Tapebas.DataCase

  import Tapebas.EventsFixtures

  alias Tapebas.Events
  alias Tapebas.Events.Comment
  alias Tapebas.Events.Event
  alias Tapebas.Events.Question
  alias Tapebas.Events.Talk

  describe "events" do
    @invalid_attrs %{slug: nil, title: nil, description: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.all() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get(id: event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      %{id: user_id} = Tapebas.AccountsFixtures.user_fixture()
      valid_attrs = %{title: "some title", description: "some description", user_id: user_id}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.slug == "some-title"
      assert event.title == "some title"
      assert event.description == "some description"
      assert event.user_id == user_id
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
      assert event == Events.get(id: event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      refute nil != Events.get(id: event.id)
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
      event = event_fixture()

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

  describe "questions" do
    @invalid_attrs %{answered: nil, title: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Events.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Events.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      %{id: user_id} = Tapebas.AccountsFixtures.user_fixture()
      %{id: talk_id} = talk_fixture()
      valid_attrs = %{answered: true, title: "some title", user_id: user_id, talk_id: talk_id}

      assert {:ok, %Question{} = question} = Events.create_question(valid_attrs)
      assert question.answered == true
      assert question.title == "some title"
      assert question.user_id == user_id
      assert question.talk_id == talk_id
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{answered: false, title: "some updated title"}

      assert {:ok, %Question{} = question} = Events.update_question(question, update_attrs)
      assert question.answered == false
      assert question.title == "some updated title"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_question(question, @invalid_attrs)
      assert question == Events.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Events.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Events.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Events.change_question(question)
    end
  end

  describe "comments" do
    @invalid_attrs %{message: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Events.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Events.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{message: "some message"}

      assert {:ok, %Comment{} = comment} = Events.create_comment(valid_attrs)
      assert comment.message == "some message"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{message: "some updated message"}

      assert {:ok, %Comment{} = comment} = Events.update_comment(comment, update_attrs)
      assert comment.message == "some updated message"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_comment(comment, @invalid_attrs)
      assert comment == Events.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Events.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Events.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Events.change_comment(comment)
    end
  end
end
