defmodule Pento.Repo.Migrations.CreateQuizs do
  use Ecto.Migration

  def change do
    create table(:quizs) do
      add :body, :text
      add :translation, :text
      add :explanation, :text
      add :image, :string
      add :solution, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
