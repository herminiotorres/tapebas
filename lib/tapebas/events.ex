defmodule Tapebas.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Tapebas.Repo

  alias Tapebas.Events.Event

  def list_events, do: list_events([])

  def list_events(criteria) do
    {order_by, criteria} = Keyword.pop(criteria, :order_by)
    {preloads, criteria} = Keyword.pop(criteria, :preload, [])

    Event
    |> where(^event_filter_where(criteria))
    |> event_do_order_by(order_by)
    |> event_maybe_preload(preloads, criteria)
    |> Repo.all()
  end

  def get_event(criteria) do
    {preloads, criteria} = Keyword.pop(criteria, :preload, [])

    Event
    |> where(^event_filter_where(criteria))
    |> event_maybe_preload(preloads, criteria)
    |> Repo.one()
  end

  defp event_filter_where(criteria) do
    Enum.reduce(criteria, dynamic(true), fn
      {:id, ids}, dynamic when is_list(ids) ->
        dynamic([e], ^dynamic and e.id in ^ids)

      {:id, id}, dynamic ->
        dynamic([e], ^dynamic and e.id == ^id)

      {:slug, slug}, dynamic ->
        dynamic([e], ^dynamic and e.slug == ^slug)

      {:user_id, user_id}, dynamic ->
        dynamic([e], ^dynamic and e.user_id == ^user_id)

      other, _dynamic ->
        raise "Unspported Event filter #{inspect(other)}"
    end)
  end

  defp event_maybe_preload(query, preloads, _criteria) do
    preloads = List.wrap(preloads || [])

    Enum.reduce(preloads, query, fn preload, query ->
      case preload do
        :talks ->
          preload(query, :talks)

        {:talks, :questions} ->
          preload(query, talks: :questions)

        {:talks, :likes} ->
          preload(query, talks: :likes)

        :user ->
          preload(query, :user)

        _ ->
          raise "Unsupported Event preload #{inspect(preload)}"
      end
    end)
  end

  defp event_do_order_by(query, {asc_or_desc, key}) do
    order_by(query, [e], [{^asc_or_desc, field(e, ^key)}])
  end

  defp event_do_order_by(query, _), do: order_by(query, [e], desc: e.inserted_at)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias Tapebas.Events.Talk

  def list_talks, do: list_talks([])

  def list_talks(criteria) do
    {order_by, criteria} = Keyword.pop(criteria, :order_by)
    {preloads, criteria} = Keyword.pop(criteria, :preload, [])

    Talk
    |> where(^talk_filter_where(criteria))
    |> talk_do_order_by(order_by)
    |> talk_maybe_preload(preloads, criteria)
    |> Repo.all()
  end

  def get_talk(criteria) do
    {preloads, criteria} = Keyword.pop(criteria, :preload, [])

    Talk
    |> where(^talk_filter_where(criteria))
    |> talk_maybe_preload(preloads, criteria)
    |> Repo.one()
  end

  defp talk_filter_where(criteria) do
    Enum.reduce(criteria, dynamic(true), fn
      {:id, ids}, dynamic when is_list(ids) ->
        dynamic([t], ^dynamic and t.id in ^ids)

      {:id, id}, dynamic ->
        dynamic([t], ^dynamic and t.id == ^id)

      {:slug, slug}, dynamic ->
        dynamic([t], ^dynamic and t.slug == ^slug)

      {:type, type}, dynamic ->
        dynamic([t], ^dynamic and t.type == ^type)

      {:speaker, speaker}, dynamic ->
        dynamic([t], ^dynamic and t.speaker == ^speaker)

      other, _dynamic ->
        raise "Unspported Talk filter #{inspect(other)}"
    end)
  end

  defp talk_maybe_preload(query, preloads, _criteria) do
    preloads = List.wrap(preloads || [])

    Enum.reduce(preloads, query, fn preload, query ->
      case preload do
        {:questions, [comments: :user]} ->
          preload(query, questions: [comments: :user])

        {:questions, :comments} ->
          preload(query, questions: :comments)

        {:questions, :user} ->
          preload(query, questions: :user)

        :questions ->
          preload(query, :questions)

        :likes ->
          preload(query, :likes)

        :event ->
          preload(query, :event)

        _ ->
          raise "Unsupported Talk preload #{inspect(preload)}"
      end
    end)
  end

  defp talk_do_order_by(query, {asc_or_desc, key}) do
    order_by(query, [t], [{^asc_or_desc, field(t, ^key)}])
  end

  defp talk_do_order_by(query, _), do: order_by(query, [t], desc: t.inserted_at)

  @doc """
  Creates a talk.

  ## Examples

      iex> create_talk(%{field: value})
      {:ok, %Talk{}}

      iex> create_talk(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_talk(attrs \\ %{}) do
    %Talk{}
    |> Talk.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a talk.

  ## Examples

      iex> update_talk(talk, %{field: new_value})
      {:ok, %Talk{}}

      iex> update_talk(talk, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_talk(%Talk{} = talk, attrs) do
    talk
    |> Talk.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a talk.

  ## Examples

      iex> delete_talk(talk)
      {:ok, %Talk{}}

      iex> delete_talk(talk)
      {:error, %Ecto.Changeset{}}

  """
  def delete_talk(%Talk{} = talk) do
    Repo.delete(talk)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking talk changes.

  ## Examples

      iex> change_talk(talk)
      %Ecto.Changeset{data: %Talk{}}

  """
  def change_talk(%Talk{} = talk, attrs \\ %{}) do
    Talk.changeset(talk, attrs)
  end

  alias Tapebas.Events.Question

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end

  alias Tapebas.Events.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  # likes talks
  alias Tapebas.Events.Like

  def like(attrs) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  def unlike(attrs) do
    with %Like{} = like <-
           attrs
           |> get_like()
           |> Repo.one() do
      Repo.delete(like)
    end
  end

  def get_like(%{user_id: user_id, talk_id: talk_id} = _attrs) do
    from l in Like, where: [user_id: ^user_id, talk_id: ^talk_id]
  end
end
