defmodule TapebasWeb.TalkLive.QuestionFormComponent do
  @moduledoc false

  use TapebasWeb, :live_component

  alias Tapebas.Events

  @impl true
  def update(%{question: question} = assigns, socket) do
    changeset = Events.change_question(question)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"question" => question_params}, socket) do
    changeset =
      socket.assigns.question
      |> Events.change_question(question_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"question" => question_params}, socket) do
    save_event(socket, socket.assigns.action, question_params)
  end

  defp save_event(socket, :edit_question, question_params) do
    case Events.update_question(socket.assigns.question, question_params) do
      {:ok, _question} ->
        pubsub_event(:edit_question)

        {:noreply,
         socket
         |> put_flash(:info, "Question updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :new_question, question_params) do
    case Events.create_question(question_params) do
      {:ok, _question} ->
        pubsub_event(:new_question)

        {:noreply,
         socket
         |> put_flash(:info, "Question created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp pubsub_event(action) do
    Phoenix.PubSub.broadcast(Tapebas.PubSub, "questions", action)
  end
end
