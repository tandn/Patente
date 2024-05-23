defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..3 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    <%= if @win do %>
      <.link patch={~p"/guess/"}> Restart</.link>
    <% end %>
    """
  end

  def handle_params(_params, _uri, socket) do
    score = socket.assigns[:score]

    if score do
      {:noreply, init_game(socket, score)}
    else
      {:noreply, init_game(socket)}
    end
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    {score, msg, win} =
      if socket.assigns.secret_number == guess do
        {socket.assigns.score + 1, "Correct!", true}
      else
        {socket.assigns.score - 1, "Wrong!", false}
      end

    message = "Your guess #{guess}. #{msg}"

    {:noreply,
     assign(socket,
       message: message,
       score: score,
       win: win
     )}
  end

  defp secret(n) do
    Enum.shuffle(1..n) |> hd |> Integer.to_string()
  end

  defp init_game(socket, score \\ 0) do
    assign(socket,
      win: nil,
      score: score,
      message: "Make a guess:",
      secret_number: secret(3)
    )
  end
end
