defmodule Pento.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        slug: "some slug",
        title: "some title"
      })
      |> Pento.Blog.create_post()

    post
  end
end
