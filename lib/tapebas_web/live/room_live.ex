defmodule TapebasWeb.RoomLive do
  @moduledoc false

  use TapebasWeb, :live_view
  require Logger

  @impl true
  def mount(%{"event_slug" => room_id}, _session, socket) do
    topic = "room:" <> room_id

    username =
      socket.assigns.current_user.email
      |> String.split("@")
      |> hd()

    if connected?(socket) do
      TapebasWeb.Endpoint.subscribe(topic)
      TapebasWeb.Presence.track(self(), topic, username, %{})
    end

    {:ok,
     assign(socket,
       room_id: room_id,
       topic: topic,
       username: username,
       message: "",
       messages: [],
       user_list: [],
       temporary_assigns: [messages: []]
     )}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    message = %{uuid: Ecto.UUID.generate(), username: socket.assigns.username, content: message}
    TapebasWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_event("form_updated", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end

  @impl true
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}, topic: _topic},
        socket
      ) do
    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username ->
        %{uuid: Ecto.UUID.generate(), content: "#{username} joined", type: :system}
      end)

    leave_messages =
      leaves
      |> Map.keys()
      |> Enum.map(fn username ->
        %{uuid: Ecto.UUID.generate(), content: "#{username} left", type: :system}
      end)

    user_list =
      socket.assigns.topic
      |> TapebasWeb.Presence.list()
      |> Map.keys()

    {:noreply, assign(socket, messages: join_messages ++ leave_messages, user_list: user_list)}
  end

  def display_message(%{type: :system, uuid: uuid, content: content}) do
    assigns = %{type: :system, uuid: uuid, content: content}

    ~H"""
    <p id={@uuid}><i><%= @content %></i></p>
    """
  end

  def display_message(%{uuid: uuid, content: content, username: username}) do
    assigns = %{uuid: uuid, content: content, username: username}

    ~H"""
    <p id={@uuid}>
      <strong><%= @username %></strong>:<span><%= @content %></span>
    </p>
    """
  end
end
