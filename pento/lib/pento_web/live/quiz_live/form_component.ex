defmodule PentoWeb.QuizLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def mount(socket) do
    {:ok, assign(socket, topics: Catalog.list_topics())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage quiz records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="quiz-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:body]} type="textarea" label="Quiz" />
        <.input field={@form[:image]} type="text" label="Image URL" />
        <.input
          field={@form[:solution]}
          type="select"
          label="Solution"
          prompt="Select an answer"
          options={[{"Vero", true}, {"Falso", false}]}
        />
        <.input
          field={@form[:topic_id]}
          type="select"
          label="Topic"
          prompt="Choose a category"
          options={topic_select_options(@topics)}
        />
        <.input field={@form[:translation]} type="textarea" label="Translation" />
        <.input field={@form[:explanation]} type="textarea" label="Explanation" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Quiz</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{quiz: quiz} = assigns, socket) do
    changeset = Catalog.change_quiz(quiz)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"quiz" => quiz_params}, socket) do
    changeset =
      socket.assigns.quiz
      |> Catalog.change_quiz(quiz_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"quiz" => quiz_params}, socket) do
    save_quiz(socket, socket.assigns.action, quiz_params)
  end

  defp save_quiz(socket, :edit, quiz_params) do
    case Catalog.update_quiz(socket.assigns.quiz, quiz_params) do
      {:ok, quiz} ->
        notify_parent({:saved, quiz})

        {:noreply,
         socket
         |> put_flash(:info, "Quiz updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_quiz(socket, :new, quiz_params) do
    case Catalog.create_quiz(quiz_params) do
      {:ok, quiz} ->
        notify_parent({:saved, quiz})

        {:noreply,
         socket
         |> put_flash(:info, "Quiz created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp topic_select_options(topics) do
    for topic <- topics, do: {topic.name, topic.id}
  end
end
