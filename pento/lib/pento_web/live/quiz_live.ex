defmodule PentoWeb.QuizLive do
  use PentoWeb, :live_view

  import PentoWeb.QuizComponent

  @number_of_quizs 30
  @time_in_sec 20 * 60

  def mount(_params, _session, socket) do
    quizs = Pento.Catalog.list_quizs() |> Enum.shuffle() |> Enum.take(@number_of_quizs)

    quizs =
      for num <- 1..min(@number_of_quizs, length(quizs)) do
        quizs
        |> Enum.at(num - 1)
        |> Map.put(:num, num)
      end

    ref = :erlang.send_after(1000, self(), :quiz_tick)

    {:ok,
     assign(socket,
       count: @time_in_sec,
       current_num: 1,
       quizs: quizs,
       quiz: current_quiz(quizs, 1),
       scores: %{},
       answers: %{},
       final: nil,
       tref: ref,
       switch_view: false,
       translated: nil,
       audio: nil
     )}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("quiz_answer", %{"num" => quiz_num, "answer" => answer}, socket) do
    quiz = socket.assigns.quiz

    # timeout
    point =
      if socket.assigns.count > 0 do
        point(answer, quiz.solution)
      else
        0
      end

    scores =
      socket.assigns.scores
      |> Map.put(quiz_num, point)

    answers =
      socket.assigns.answers |> Map.put(quiz_num, answer)

    {:noreply, assign(socket, scores: scores, answers: answers)}
  end

  def handle_event("switch_view", _unsigned_params, socket) do
    {:noreply, assign(socket, switch_view: not socket.assigns.switch_view)}
  end

  def handle_event("quiz_next", _unsigned_params, socket) do
    current_num = socket.assigns.current_num

    if current_num >= @number_of_quizs do
      {:noreply, socket}
    else
      quizs = socket.assigns.quizs

      {:noreply,
       assign(socket,
         quiz: current_quiz(quizs, current_num + 1),
         current_num: current_num + 1
       )}
    end
  end

  def handle_event("quiz_select", %{"num" => num}, socket) do
    current_num = socket.assigns.current_num
    num = num |> String.to_integer()

    if current_num == num do
      {:noreply, socket}
    else
      quizs = socket.assigns.quizs

      {:noreply,
       assign(socket,
         quiz: current_quiz(quizs, num),
         current_num: num
       )}
    end
  end

  def handle_event("quiz_prev", _unsigned_params, socket) do
    current_num = socket.assigns.current_num

    if current_num <= 1 do
      {:noreply, socket}
    else
      quizs = socket.assigns.quizs

      {:noreply,
       assign(socket,
         quiz: current_quiz(quizs, current_num - 1),
         current_num: current_num - 1
       )}
    end
  end

  def handle_event("quiz_explain", _unsigned_params, socket) do
    :erlang.cancel_timer(socket.assigns.tref)
    {:noreply, assign(socket, final: socket.assigns.scores |> Map.values() |> Enum.sum())}
  end

  def handle_event("quiz_translate", _unsigned_params, socket) do
    send(self(), :run_translate_request)
    socket = push_event(socket, "js-exec", %{to: "#my_spinner", attr: "data-plz-wait"})

    {:noreply, socket}
  end

  def handle_event("quiz_audio", _unsigned_params, socket) do
    send(self(), :run_audio_request)
    socket = push_event(socket, "js-exec", %{to: "#my_spinner", attr: "data-plz-wait"})

    {:noreply, socket}
  end

  def handle_info(:quiz_tick, socket) do
    count = socket.assigns.count

    if count > 0 do
      ref = :erlang.send_after(1000, self(), :quiz_tick)
      {:noreply, assign(socket, count: count - 1, tref: ref)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:run_translate_request, socket) do
    translated = get_translated(socket.assigns.quiz.body)

    socket = push_event(socket, "js-exec", %{to: "#my_spinner", attr: "translate-done"})

    {:noreply, assign(socket, translated: translated)}
  end

  def handle_info(:run_audio_request, socket) do
    audio = get_audio(socket.assigns.quiz.body)

    socket = push_event(socket, "js-exec", %{to: "#my_spinner", attr: "audio-done"})
    ## TODO
    {:noreply, assign(socket, audio: "/mp3/path/file.mp3")}
  end

  defp get_translated(text) do
    url = PentoWeb.Endpoint.config(:lecto_url)

    headers = [
      {"X-API-Key", PentoWeb.Endpoint.config(:lecto_api_key)},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]

    body = Jason.encode!(%{texts: [text], to: ["en"], from: "it"})

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.post(url, body, headers),
         {:ok, %{"translations" => [%{"translated" => [translated]}]}} <-
           Jason.decode(body) do
      translated
    else
      _ ->
        nil
    end
  end

  defp get_audio(text) do
    url = PentoWeb.Endpoint.config(:playht_url)

    headers = [
      {"AUTHORIZATION", "Bearer " <> PentoWeb.Endpoint.config(:playht_api_key)},
      {"X-USER-ID", PentoWeb.Endpoint.config(:playht_user_id)},
      {"Content-Type", "application/json"},
      {"Accept", "audio/mpeg"}
    ]

    body =
      Jason.encode!(%{
        text: text,
        voice:
          "s3://voice-cloning-zero-shot/7ced805f-611e-433c-8c43-568f48a8af4e/original/manifest.json",
        output_format: "mp3"
      })

    with {:ok, %HTTPoison.Response{status_code: 200, body: audio}} <-
           HTTPoison.post(url, body, headers) do
      audio
    else
      err ->
        IO.inspect(err)
        nil
    end
  end

  defp point("vero", true), do: 1
  defp point("falso", false), do: 1
  defp point(_, _), do: 0

  defp current_quiz(quizs, quiz_id) do
    quizs |> Enum.at(quiz_id - 1)
  end

  def format_timer(count) do
    {m, s} = {div(count, 60), rem(count, 60)}
    "#{format_unit(m)}:#{format_unit(s)}"
  end

  defp format_unit(u) when u < 10, do: "0#{u}"
  defp format_unit(u), do: u
end
