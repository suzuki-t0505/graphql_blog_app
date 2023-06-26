defmodule BlogApi.Resolver.Posts do
  alias BlogApi.Posts

  def get_posts(_root, _args, _info) do
    {:ok, Posts.list_posts()}
  end
end
