defmodule BlogApi.Resolver.Posts do
  alias BlogApi.Posts
  alias BlogApi.Posts.Post

  def get_posts(_root, _args, _info) do
    {:ok, Posts.list_posts()}
  end

  def get_post(_root, %{id: id}, _info) do
    case Posts.get_post(id) do
      nil ->
        {:error, "Could not get post."}

      %Post{} = post -> {:ok, post}
    end
  end

  def create_post(_root, args, _info) do
    case Posts.create_post(args) do
      {:ok, post} ->
        {:ok, post}

      {:error, _cs} ->
        {:error, "Could not create post."}
    end
  end

  def update_post(_root, %{id: id} = args, _info) do
    with %Post{} = post <- Posts.get_post(id),
      {:ok, post} <- Posts.update_post(post, args) do

        {:ok, post}
    else
      _ -> {:error, "Could not update post."}
    end
  end

  def delete_post(_root, %{id: id}, _info) do
    with %Post{} = post <- Posts.get_post(id),
      {:ok, post} <- Posts.delete_post(post) do
        {:ok, post}
    else
      _ -> {:error, "Could not delete post."}
    end
  end
end
