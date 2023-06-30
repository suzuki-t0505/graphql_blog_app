defmodule ElixirBlogAppWeb.PageLive do
  use ElixirBlogAppWeb, :live_view

  alias ElixirBlogApp.Posts

  def render(assigns) do
    ~H"""
    <h1>ブログ一覧</h1>
    <%= for post <- @posts do %>
    <div>
      <%= post["title"] %>
      <%= post["body"] %>
    </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "ブログ一覧")
      |> assign(:posts, Posts.list_posts())

    {:ok, socket}
  end
end
