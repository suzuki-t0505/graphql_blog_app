defmodule ElixirBlogAppWeb.RegistrationLive do
  use ElixirBlogAppWeb, :live_view
  alias ElixirBlogApp.Accounts

  def render(assigns) do
    ~H"""
    <h1>登録</h1>

    <.simple_form for={@form}
      id="register_form"
      phx-change="validate"
      phx-submit="save"
      phx-trigger-action={@trigger_submit}
      action={~p"/log_in?_action=registered"}
      method="post"
    >
      <.input field={@form[:email]} type="email" label="Email" required />
      <.input field={@form[:password]} type="password" label="Password" required />

      <:actions>
        <.button phx-disabled-with="creating...">Create a account</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session ,socket) do
    cs = Accounts.account_changeset(%{})

    IO.inspect(to_form(cs, as: :account))

    socket =
      socket
      |> assign(:trigger_submit, false)
      |> create_form(cs)
    {:ok, socket}
  end

  def handle_event("validate", %{"account" => params}, socket) do
    cs = Accounts.account_changeset(%{}, params)
    {:noreply, create_form(socket, cs)}
  end

  def handle_event("save", %{"account" => params}, socket) do
    socket =
      case Accounts.create_account(params) do
        {:ok, account} ->
          cs = Accounts.account_changeset(account, params)

          socket
          |> assign(trigger_submit: true)
          |> create_form(cs)

        {:error, cs} ->
          create_form(socket, cs)
      end

    {:noreply, socket}
  end

  defp create_form(socket, cs) do
    assign(socket, :form, to_form(cs, as: :account))
  end
end
