defmodule TapebasWeb.EventLive.Show do
  @moduledoc false

  use TapebasWeb, :live_view

  alias TapebasWeb.Components.Icon

  alias Tapebas.Events

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    if event = Events.get(slug: slug, preload: [talks: :questions]) do
      {:ok, assign(socket, event: event)}
    else
      socket =
        socket
        |> put_flash(:error, "Event not found.")
        |> redirect(to: Routes.event_index_path(socket, :index))

      {:ok, socket}
    end
  end
end
