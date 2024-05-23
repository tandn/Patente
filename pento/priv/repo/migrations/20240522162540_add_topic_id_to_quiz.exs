defmodule Pento.Repo.Migrations.AddTopicIdToQuiz do
  use Ecto.Migration

  def change do
    alter table(:quizs) do
      add :topic_id, references(:topics)
    end
  end
end
