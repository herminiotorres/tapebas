defmodule TapebasWeb.EventLive.Index do
  @moduledoc false

  use TapebasWeb, :live_view

  on_mount {TapebasWeb.MountHelpers, :pubsub_events}

  alias TapebasWeb.Components.Icon

  alias Tapebas.Events
  alias Tapebas.Events.Event

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, events: Tapebas.Events.list_events())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:new_event, socket) do
    {:noreply, push_redirect(socket, to: Routes.event_index_path(socket, :index))}
  end

  @impl true
  def handle_info(:edit_event, socket) do
    {:noreply, push_redirect(socket, to: Routes.event_index_path(socket, :index))}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Events.get_event(id: id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Events")
  end
end
