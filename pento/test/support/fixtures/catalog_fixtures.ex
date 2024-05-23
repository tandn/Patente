defmodule Pento.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Catalog` context.
  """

  @doc """
  Generate a quiz.
  """
  def quiz_fixture(attrs \\ %{}) do
    {:ok, quiz} =
      attrs
      |> Enum.into(%{
        answer: true,
        content: "some content",
        explanation: "some explanation",
        img: "some img",
        translation: "some translation"
      })
      |> Pento.Catalog.create_quiz()

    quiz
  end
end
