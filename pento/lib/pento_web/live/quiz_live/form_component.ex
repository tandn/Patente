defmodule PentoWeb.QuizLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog
  alias Pento.Catalog.Quiz

  @impl true
  def mount(socket) do
    socket =
      allow_upload(
        socket,
        :image,
        accept: ~w(.png .jpeg .jpg),
        max_file_size: 10_000_000
      )

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
        <div class="text-gray-500 text-sm">
          <.live_file_input upload={@uploads.image} />
          <span class="block">Add up to <%= @uploads.image.max_entries %> images
            (max <%= trunc(@uploads.image.max_file_size / 1_000_000) %> MB)</span>
        </div>
        <%= for entry <- @uploads.image.entries do %>
          <.live_img_preview entry={entry} width="75" />
          <div class="flex justify-between items-center">
            <div class="w-full border bg-gray-100 ">
              <span class="border text-xs bg-blue-100 py-1" style={"width=#{entry.progress}%"}>
                <%= entry.progress %>%
              </span>
            </div>
            <a
              href="#"
              class="text-2xl"
              phx-click="cancel-upload"
              phx-target={@myself}
              phx-value-ref={entry.ref}
            >
              &times;
            </a>
          </div>
        <% end %>
        <!--.button class="w-full" phx-disable-with="Uploading...">Upload</.button-->
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

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp save_quiz(socket, :edit, quiz_params) do
    quiz_params =
      case consume_uploaded(socket) do
        [] -> quiz_params
        [url] -> %{quiz_params | "image" => url}
      end

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
    [image_url] = consume_uploaded(socket)
    quiz = %Quiz{image: image_url}

    case Catalog.update_quiz(quiz, quiz_params) do
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

  defp consume_uploaded(socket) do
    consume_uploaded_entries(socket, :image, fn meta, entry ->
      dest = Path.join("priv/static/uploads", filename(entry))
      File.cp!(meta.path, dest)
      {:ok, ~p"/uploads/#{filename(entry)}"}
    end)
  end

  defp filename(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end
end
