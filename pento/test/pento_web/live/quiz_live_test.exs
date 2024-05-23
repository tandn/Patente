defmodule PentoWeb.QuizLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pento.CatalogFixtures

  @create_attrs %{
    content: "some content",
    translation: "some translation",
    explanation: "some explanation",
    img: "some img",
    answer: true
  }
  @update_attrs %{
    content: "some updated content",
    translation: "some updated translation",
    explanation: "some updated explanation",
    img: "some updated img",
    answer: false
  }
  @invalid_attrs %{content: nil, translation: nil, explanation: nil, img: nil, answer: false}

  defp create_quiz(_) do
    quiz = quiz_fixture()
    %{quiz: quiz}
  end

  describe "Index" do
    setup [:create_quiz]

    test "lists all quizs", %{conn: conn, quiz: quiz} do
      {:ok, _index_live, html} = live(conn, ~p"/quizs")

      assert html =~ "Listing Quizs"
      assert html =~ quiz.content
    end

    test "saves new quiz", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/quizs")

      assert index_live |> element("a", "New Quiz") |> render_click() =~
               "New Quiz"

      assert_patch(index_live, ~p"/quizs/new")

      assert index_live
             |> form("#quiz-form", quiz: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#quiz-form", quiz: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/quizs")

      html = render(index_live)
      assert html =~ "Quiz created successfully"
      assert html =~ "some content"
    end

    test "updates quiz in listing", %{conn: conn, quiz: quiz} do
      {:ok, index_live, _html} = live(conn, ~p"/quizs")

      assert index_live |> element("#quizs-#{quiz.id} a", "Edit") |> render_click() =~
               "Edit Quiz"

      assert_patch(index_live, ~p"/quizs/#{quiz}/edit")

      assert index_live
             |> form("#quiz-form", quiz: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#quiz-form", quiz: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/quizs")

      html = render(index_live)
      assert html =~ "Quiz updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes quiz in listing", %{conn: conn, quiz: quiz} do
      {:ok, index_live, _html} = live(conn, ~p"/quizs")

      assert index_live |> element("#quizs-#{quiz.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#quizs-#{quiz.id}")
    end
  end

  describe "Show" do
    setup [:create_quiz]

    test "displays quiz", %{conn: conn, quiz: quiz} do
      {:ok, _show_live, html} = live(conn, ~p"/quizs/#{quiz}")

      assert html =~ "Show Quiz"
      assert html =~ quiz.content
    end

    test "updates quiz within modal", %{conn: conn, quiz: quiz} do
      {:ok, show_live, _html} = live(conn, ~p"/quizs/#{quiz}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Quiz"

      assert_patch(show_live, ~p"/quizs/#{quiz}/show/edit")

      assert show_live
             |> form("#quiz-form", quiz: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#quiz-form", quiz: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/quizs/#{quiz}")

      html = render(show_live)
      assert html =~ "Quiz updated successfully"
      assert html =~ "some updated content"
    end
  end
end
