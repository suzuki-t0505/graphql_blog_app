defmodule BlogApi.Resolver.Posts do
  alias BlogApi.Posts

  def get_posts(_root, _args, _info) do
    {:ok, Posts.list_posts()}
  end

  def create_posts(_root, args, _info) do
    case Posts.create_post(args) do
      {:ok, post} ->
        {:ok, post}
        
      {:error, _cs} ->
        {:error, "Could not create post."}
    end
  end
end
