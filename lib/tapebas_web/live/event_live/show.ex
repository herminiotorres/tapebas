defmodule TapebasWeb.EventLive.Show do
  @moduledoc false

  use TapebasWeb, :live_view

  on_mount {TapebasWeb.MountHelpers, :pubsub_talks}

  alias TapebasWeb.Components.Icon

  alias Tapebas.Events
  alias Tapebas.Events.Talk

  @impl true
  def mount(%{"event_slug" => slug}, _session, socket) do
    if event = Events.get_event(slug: slug, preload: [talks: :questions, talks: :likes]) do
      socket =
        socket
        |> assign(event: event)

      {:ok, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Event not found.")
        |> redirect(to: Routes.event_index_path(socket, :index))

      {:ok, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("like", %{"talk-id" => talk_id, "user-id" => user_id}, socket) do
    Events.like(%{talk_id: talk_id, user_id: user_id})

    event =
      Events.get_event(id: socket.assigns.event.id, preload: [talks: :questions, talks: :likes])

    socket =
      socket
      |> assign(event: event)

    {:noreply, socket}
  end

  @impl true
  def handle_event("unlike", %{"talk-id" => talk_id, "user-id" => user_id}, socket) do
    Events.unlike(%{talk_id: talk_id, user_id: user_id})

    event =
      Events.get_event(id: socket.assigns.event.id, preload: [talks: :questions, talks: :likes])

    socket =
      socket
      |> assign(event: event)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:new_talk, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.event_show_path(socket, :show, socket.assigns.event.slug))}
  end

  @impl true
  def handle_info(:edit_talk, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.event_show_path(socket, :show, socket.assigns.event.slug))}
  end

  defp apply_action(socket, :edit_talk, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Talk")
    |> assign(:talk, Events.get_talk(id: id))
  end

  defp apply_action(socket, :new_talk, _params) do
    socket
    |> assign(:page_title, "New Talk")
    |> assign(:talk, %Talk{})
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Events")
  end
end
