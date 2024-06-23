defmodule PentoWeb.QuizComponent do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  def quiz_box(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-2 mt-4">
      <div class="flex items-center justify-center col-span-1 ml-2 bg-white">
        <img src={@quiz.image} alt="" />
      </div>

      <div class="col-span-2 mr-2">
        <div class="bg-white">
          <span class="flex justify-end mr-2 text-2xl text-gray-500 font-Arial">
            <%= @quiz.num %>
          </span>

          <div class="flex-col flex py-10 px-2 h-72 justify-center">
            <p class="text-xl"><%= @quiz.body %></p>
            <.loader id="my_spinner" />
          </div>
          <span class="flex justify-end mx-2 gap-2 pb-4">
            <PentoWeb.CoreComponents.icon
              name="hero-language-solid"
              class="w-7 h-7 hover:cursor-pointer "
              phx-click={JS.push("quiz_translate")}
            />
            <PentoWeb.CoreComponents.icon
              name="hero-speaker-x-mark-solid"
              class="w-7 h-7 hover:cursor-pointer "
              phx-click={JS.push("quiz_audio")}
            />
          </span>
        </div>

        <div class="pb-4 mt-2 bg-white flex items-center justify-center gap-10">
          <.btn_quiz quiz={@quiz} type="true" answer={@answer} final={@final} />
          <.btn_quiz quiz={@quiz} type="false" answer={@answer} final={@final} />
        </div>
      </div>
    </div>
    """
  end

  def btn_quiz(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <h1 class="text-xs font-bold capitalize"><%= @type %></h1>
      <div class="flex border-blue-900 border-2 items-center shadow-md">
        <button
          class={
            ~w(btn-quiz) ++
              decorate_clicked(@type, @answer) ++
              decorate_solution(@final, to_string(@quiz.solution), @type, @answer)
          }
          phx-click={if !@final, do: JS.push("quiz_answer", value: %{answer: @type, num: @quiz.num})}
        >
          <span class="p-2 text-4xl font-normal capitalize">
            <%= display_letter(@type) %>
          </span>
        </button>
      </div>
    </div>
    """
  end

  def loader(assigns) do
    ~H"""
    <div
      class="hidden mx-auto"
      id={@id}
      data-wait={show_loader(@id)}
      audio-done={hide_loader_and_speech(@id)}
      translate-done={hide_loader_and_translate(@id)}
    >
      <div class="hollow-dots-spinner" style="spinnerStyle">
        <div class="dot"></div>
        <div class="dot"></div>
        <div class="dot"></div>
      </div>
    </div>
    """
  end

  def show_loader(js \\ %JS{}, id) do
    JS.show(js,
      to: "##{id}",
      transition: {"ease-out duration-300", "opacity-0", "opacity-100"}
    )
  end

  def hide_loader(js \\ %JS{}, id) do
    JS.hide(js,
      to: "##{id}",
      transition: {"ease-in duration-300", "opacity-100", "opacity-0"}
    )
  end

  def hide_loader_and_translate(js \\ %JS{}, id) do
    hide_loader(js, id)
    |> PentoWeb.CoreComponents.show_modal("translate_quiz")
  end

  def hide_loader_and_speech(js \\ %JS{}, id) do
    hide_loader(js, id)
    |> PentoWeb.CoreComponents.show_modal("play_audio")
  end

  defp decorate_clicked(same, same), do: ~w(btn-clicked)
  defp decorate_clicked(_, _), do: ~w()

  defp decorate_solution(nil, _, _, _), do: ~w()
  defp decorate_solution(_, _, same, same), do: ~w()
  defp decorate_solution(_, same, same, _), do: ~w(btn-solution)
  defp decorate_solution(_, _, _, _), do: ~w()

  defp display_letter("true"), do: "v"
  defp display_letter("false"), do: "f"
end
