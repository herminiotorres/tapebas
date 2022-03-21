defmodule TapebasWeb.EventLive.Index do
  @moduledoc false

  use TapebasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, events: Tapebas.Events.list_events())}
  end
end
