defmodule TapebasWeb.TalkLive.CommentFormComponent do
  @moduledoc false

  use TapebasWeb, :live_component

  alias Tapebas.Events

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Events.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Events.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_event(socket, socket.assigns.action, comment_params)
  end

  defp save_event(socket, :edit_comment, comment_params) do
    case Events.update_comment(socket.assigns.event, comment_params) do
      {:ok, _event} ->
        pubsub_event(:new_comment)

        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :new_comment, comment_params) do
    case Events.create_comment(comment_params) do
      {:ok, _event} ->
        pubsub_event(:new_comment)

        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp pubsub_event(action) do
    Phoenix.PubSub.broadcast(Tapebas.PubSub, "comments", action)
  end
end
