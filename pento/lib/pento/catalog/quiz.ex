defmodule Pento.Catalog.Quiz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quizs" do
    field :body, :string
    field :translation, :string
    field :explanation, :string
    field :image, :string
    field :solution, :boolean
    belongs_to :topic, Pento.Catalog.Topic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:body, :translation, :explanation, :image, :solution, :topic_id])
    |> validate_required([:body, :solution])
  end
end
