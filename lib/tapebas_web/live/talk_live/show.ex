defmodule TapebasWeb.TalkLive.Show do
  @moduledoc false

  use TapebasWeb, :live_view

  alias TapebasWeb.Components.Icon

  alias Tapebas.Events

  @impl true
  def mount(%{"event_slug" => slug, "talk_id" => talk_id}, _session, socket) do
    if talk =
         Events.get_talk(id: talk_id, preload: [questions: :user, questions: [comments: :user]]) do
      socket =
        socket
        |> assign(talk: talk)

      {:ok, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Talk not found.")
        |> redirect(to: Routes.event_show_path(socket, :show, slug))

      {:ok, socket}
    end
  end
end
