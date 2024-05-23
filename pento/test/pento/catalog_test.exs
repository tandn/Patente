defmodule Pento.CatalogTest do
  use Pento.DataCase

  alias Pento.Catalog

  describe "quizs" do
    alias Pento.Catalog.Quiz

    import Pento.CatalogFixtures

    @invalid_attrs %{}

    test "list_quizs/0 returns all quizs" do
      quiz = quiz_fixture()
      assert Catalog.list_quizs() == [quiz]
    end

    test "get_quiz!/1 returns the quiz with given id" do
      quiz = quiz_fixture()
      assert Catalog.get_quiz!(quiz.id) == quiz
    end

    test "create_quiz/1 with valid data creates a quiz" do
      valid_attrs = %{}

      assert {:ok, %Quiz{} = quiz} = Catalog.create_quiz(valid_attrs)
    end

    test "create_quiz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_quiz(@invalid_attrs)
    end

    test "update_quiz/2 with valid data updates the quiz" do
      quiz = quiz_fixture()
      update_attrs = %{}

      assert {:ok, %Quiz{} = quiz} = Catalog.update_quiz(quiz, update_attrs)
    end

    test "update_quiz/2 with invalid data returns error changeset" do
      quiz = quiz_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_quiz(quiz, @invalid_attrs)
      assert quiz == Catalog.get_quiz!(quiz.id)
    end

    test "delete_quiz/1 deletes the quiz" do
      quiz = quiz_fixture()
      assert {:ok, %Quiz{}} = Catalog.delete_quiz(quiz)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_quiz!(quiz.id) end
    end

    test "change_quiz/1 returns a quiz changeset" do
      quiz = quiz_fixture()
      assert %Ecto.Changeset{} = Catalog.change_quiz(quiz)
    end
  end

  describe "quizs" do
    alias Pento.Catalog.Quiz

    import Pento.CatalogFixtures

    @invalid_attrs %{content: nil, translation: nil, explanation: nil, img: nil, answer: nil}

    test "list_quizs/0 returns all quizs" do
      quiz = quiz_fixture()
      assert Catalog.list_quizs() == [quiz]
    end

    test "get_quiz!/1 returns the quiz with given id" do
      quiz = quiz_fixture()
      assert Catalog.get_quiz!(quiz.id) == quiz
    end

    test "create_quiz/1 with valid data creates a quiz" do
      valid_attrs = %{
        content: "some content",
        translation: "some translation",
        explanation: "some explanation",
        img: "some img",
        answer: true
      }

      assert {:ok, %Quiz{} = quiz} = Catalog.create_quiz(valid_attrs)
      assert quiz.content == "some content"
      assert quiz.translation == "some translation"
      assert quiz.explanation == "some explanation"
      assert quiz.img == "some img"
      assert quiz.answer == true
    end

    test "create_quiz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_quiz(@invalid_attrs)
    end

    test "update_quiz/2 with valid data updates the quiz" do
      quiz = quiz_fixture()

      update_attrs = %{
        content: "some updated content",
        translation: "some updated translation",
        explanation: "some updated explanation",
        img: "some updated img",
        answer: false
      }

      assert {:ok, %Quiz{} = quiz} = Catalog.update_quiz(quiz, update_attrs)
      assert quiz.content == "some updated content"
      assert quiz.translation == "some updated translation"
      assert quiz.explanation == "some updated explanation"
      assert quiz.img == "some updated img"
      assert quiz.answer == false
    end

    test "update_quiz/2 with invalid data returns error changeset" do
      quiz = quiz_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_quiz(quiz, @invalid_attrs)
      assert quiz == Catalog.get_quiz!(quiz.id)
    end

    test "delete_quiz/1 deletes the quiz" do
      quiz = quiz_fixture()
      assert {:ok, %Quiz{}} = Catalog.delete_quiz(quiz)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_quiz!(quiz.id) end
    end

    test "change_quiz/1 returns a quiz changeset" do
      quiz = quiz_fixture()
      assert %Ecto.Changeset{} = Catalog.change_quiz(quiz)
    end
  end
end
