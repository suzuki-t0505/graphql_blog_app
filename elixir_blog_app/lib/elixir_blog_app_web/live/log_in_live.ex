defmodule ElixirBlogAppWeb.LogInLive do
  use ElixirBlogAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>ログイン</h1>

    <.simple_form for={@form}
      id="log_in_form"
      action={~p"/log_in"}
      phx-update="ignore"
    >
      <.input field={@form[:email]} type="email" label="Email" required />
      <.input field={@form[:password]} type="password" label="Password" required />

      <:actions>
        <.button phx-disable-with="Login..." class="w-full">
          Log in
        </.button>
      </:actions>
    </.simple_form>
    """
  end


  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "account")

    socket =
      socket
      |> assign(:pate_title, "ログイン")
      |> assign(:form, form)

    {:ok, socket, temporary_assigns: [form: form]}
  end
end
