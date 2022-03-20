defmodule TapebasWeb.EventLive.Show do
  @moduledoc false

  use TapebasWeb, :live_view

  alias TapebasWeb.Components.Icon

  alias Tapebas.Events

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    if event = Events.get(slug: slug, preload: [talks: :questions]) do
      socket =
        socket
        |> assign(event: event)
        |> track_users()

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
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{readers: count}} = socket
      ) do
    readers = count + map_size(joins) - map_size(leaves)
    {:noreply, assign(socket, :readers, readers)}
  end

  defp track_users(socket) do
    topic = "event:#{socket.assigns.event.slug}"
    readers = topic |> TapebasWeb.Presence.list() |> map_size()

    if connected?(socket) do
      TapebasWeb.Endpoint.subscribe(topic)
      TapebasWeb.Presence.track(self(), topic, socket.id, %{id: socket.id})
    end

    assign(socket, :readers, readers)
  end
end
