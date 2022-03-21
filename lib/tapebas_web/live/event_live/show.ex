defmodule TapebasWeb.EventLive.Show do
  @moduledoc false

  use TapebasWeb, :live_view

  alias TapebasWeb.Components.Icon

  alias Tapebas.Events

  @impl true
  def mount(%{"event_slug" => slug}, _session, socket) do
    if event = Events.get_event(slug: slug, preload: [talks: :questions]) do
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
end
