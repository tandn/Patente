defmodule PentoWeb.QuizLive.Index do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Quiz

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :quizs, Catalog.list_quizs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Quiz")
    |> assign(:quiz, Catalog.get_quiz!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Quiz")
    |> assign(:quiz, %Quiz{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Quizs")
    |> assign(:quiz, nil)
  end

  @impl true
  def handle_info({PentoWeb.QuizLive.FormComponent, {:saved, quiz}}, socket) do
    {:noreply, stream_insert(socket, :quizs, quiz)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    quiz = Catalog.get_quiz!(id)
    {:ok, _} = Catalog.delete_quiz(quiz)

    {:noreply, stream_delete(socket, :quizs, quiz)}
  end
end
