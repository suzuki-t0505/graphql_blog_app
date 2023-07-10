defmodule BlogApi.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BlogApi.Posts` context.
  """

  alias BlogApi.Repo
  alias BlogApi.Posts.Post

  @doc """
  Generate a post.

  - title: "test"
  - body: "testtest\ntesttest"
  - type: 1

  - account_id

  """
  def post_fixture(%{account_id: account_id} = attrs) do
    title = Map.get(attrs, :title, "test")
    body = Map.get(attrs, :body, "testtest\ntesttest")
    type = Map.get(attrs, :type, 1)

    submit_datetime =
      if type != 0, do: DateTime.truncate(DateTime.utc_now(), :second)

    Repo.insert!(
      %Post{
        title: title,
        body: body,
        type: type,
        submit_datetime: submit_datetime,
        account_id: account_id
      }
    )

    # {:ok, post} =
    #   attrs
    #   |> Enum.into(%{
    #     body: "some body",
    #     title: "some title",
    #     type: 42
    #   })
    #   |> BlogApi.Posts.create_post()

    # post
  end
end
