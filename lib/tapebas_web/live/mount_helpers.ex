defmodule TapebasWeb.MountHelpers do
  @moduledoc false

  import Phoenix.LiveView

  def on_mount(:auth, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      socket
      |> assign(:current_user, Tapebas.Accounts.get_user_by_session_token(user_token))

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end

  def on_mount(:pubsub_events, _params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Tapebas.PubSub, "events")
    end

    {:cont, socket}
  end

  def on_mount(:pubsub_talks, _params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Tapebas.PubSub, "talks")
    end

    {:cont, socket}
  end

  def on_mount(:pubsub_questions, _params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Tapebas.PubSub, "questions")
    end

    {:cont, socket}
  end

  def on_mount(:pubsub_comments, _params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Tapebas.PubSub, "comments")
    end

    {:cont, socket}
  end
end
