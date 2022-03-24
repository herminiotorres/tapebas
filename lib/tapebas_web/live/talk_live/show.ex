defmodule TapebasWeb.TalkLive.Show do
  @moduledoc false

  use TapebasWeb, :live_view

  on_mount {TapebasWeb.MountHelpers, :pubsub_questions}
  on_mount {TapebasWeb.MountHelpers, :pubsub_comments}

  alias Tapebas.Events
  alias Tapebas.Events.Comment
  alias Tapebas.Events.Question

  @impl true
  def mount(
        %{"event_slug" => event_slug, "talk_slug" => talk_slug, "question_id" => question_id},
        _session,
        socket
      ) do
    if talk =
         Events.get_talk(
           slug: talk_slug,
           preload: [:event, questions: :user, questions: [comments: :user]]
         ) do
      socket =
        socket
        |> assign(talk: talk)
        |> assign(question_id: question_id)

      {:ok, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Talk not found.")
        |> redirect(to: Routes.event_show_path(socket, :show, event_slug))

      {:ok, socket}
    end
  end

  @impl true
  def mount(%{"event_slug" => event_slug, "talk_slug" => talk_slug}, _session, socket) do
    if talk =
         Events.get_talk(
           slug: talk_slug,
           preload: [:event, questions: :user, questions: [comments: :user]]
         ) do
      socket =
        socket
        |> assign(talk: talk)

      {:ok, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Talk not found.")
        |> redirect(to: Routes.event_show_path(socket, :show, event_slug))

      {:ok, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:new_question, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.talk_show_path(
           socket,
           :show,
           socket.assigns.talk.event.slug,
           socket.assigns.talk.slug
         )
     )}
  end

  @impl true
  def handle_info(:edit_question, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.talk_show_path(
           socket,
           :show,
           socket.assigns.talk.event.slug,
           socket.assigns.talk.slug
         )
     )}
  end

  @impl true
  def handle_info(:new_comment, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.talk_show_path(
           socket,
           :show,
           socket.assigns.talk.event.slug,
           socket.assigns.talk.slug
         )
     )}
  end

  @impl true
  def handle_info(:edit_comment, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.talk_show_path(
           socket,
           :show,
           socket.assigns.talk.event.slug,
           socket.assigns.talk.slug
         )
     )}
  end

  defp apply_action(socket, :edit_question, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Question")
    |> assign(:question, Events.get_question!(id))
  end

  defp apply_action(socket, :new_question, _params) do
    socket
    |> assign(:page_title, "New Question")
    |> assign(:question, %Question{})
  end

  defp apply_action(socket, :edit_comment, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit comment")
    |> assign(:comment, Events.get_comment!(id))
  end

  defp apply_action(socket, :new_comment, _params) do
    socket
    |> assign(:page_title, "New comment")
    |> assign(:comment, %Comment{})
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Talk")
  end
end
