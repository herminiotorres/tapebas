defmodule TapebasWeb.TalkLive.FormComponent do
  @moduledoc false

  use TapebasWeb, :live_component

  alias Tapebas.Events

  @impl true
  def update(%{talk: talk} = assigns, socket) do
    changeset = Events.change_talk(talk)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"talk" => talk_params}, socket) do
    changeset =
      socket.assigns.talk
      |> Events.change_talk(talk_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"talk" => talk_params}, socket) do
    save_event(socket, socket.assigns.action, talk_params)
  end

  defp save_event(socket, :edit_talk, talk_params) do
    case Events.update_talk(socket.assigns.event, talk_params) do
      {:ok, _talk} ->
        pubsub_event(:new_talk)

        {:noreply,
         socket
         |> put_flash(:info, "Talk updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :new_talk, talk_params) do
    case Events.create_talk(talk_params) do
      {:ok, _talk} ->
        pubsub_event(:new_talk)

        {:noreply,
         socket
         |> put_flash(:info, "Talk created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp pubsub_event(action) do
    Phoenix.PubSub.broadcast(Tapebas.PubSub, "talks", action)
  end
end
