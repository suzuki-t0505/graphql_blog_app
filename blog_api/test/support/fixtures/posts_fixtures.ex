defmodule BlogApi.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BlogApi.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title",
        type: 42
      })
      |> BlogApi.Posts.create_post()

    post
  end
end