defmodule ElixirBlogAppWeb.PostLive do
  use ElixirBlogAppWeb, :live_view
  alias ElixirBlogApp.Posts

  def render(assigns) do
    ~H"""
    <h1>記事作成</h1>

    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.input field={@form[:title]} type="text" label="Title" />

      <.input field={@form[:body]} type="textarea" label="Body" />
      <.input field={@form[:type]} type="select" label="Type" options={[draft: 0, public: 1, limited: 2]} />

      <:actions>
        <.button phx-disabled-with="posting...">Post</.button>
      </:actions>
    </.simple_form>

    """
  end


  def mount(_params, session, socket) do
    cs = Posts.post_changeset(%{type: 1})
    socket =
      socket
      |> assign(:token, session["account_token"])
      |> assign(:page_title, "記事作成")
      |> create_form(cs)

    {:ok, socket}
  end

  def handle_event("validate", %{"post" => params}, socket) do
    cs = Posts.post_changeset(%{}, params)
    {:noreply, create_form(socket, cs)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    socket =
      case Posts.create_post(params, socket.assigns.token) do
        {:ok, _post} ->
          socket
          |> put_flash(:info, "created post successfully!")
          |> redirect(to: ~p"/")

        {:error, cs} ->
          create_form(socket, cs)
      end

    {:noreply, socket}
  end

  defp create_form(socket, cs) do
    assign(socket, :form, to_form(cs, as: :post))
  end
end
