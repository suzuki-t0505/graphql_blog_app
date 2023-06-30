defmodule ElixirBlogAppWeb.AccountAuth do
  use ElixirBlogAppWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller
  alias ElixirBlogApp.Accounts

  def log_in_account(conn, token) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_session(:account_token, token)
    |> redirect(to: ~p"/")
  end

  def log_out_account(conn) do
    token = get_session(conn, :account_token)
    Accounts.log_out_account(token)

    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> redirect(to: ~p"/")
  end

  def fetch_current_account(conn, _opts) do
    {token, conn} = ensure_account_token(conn)
    current_account = Accounts.get_current_account(token)
    assign(conn, :current_account, current_account)
  end

  defp ensure_account_token(conn) do
    if token = get_session(conn, :account_token) do
      {token, conn}
    else
      {nil, conn}
    end
  end

  def redirect_if_account_is_authenticated(conn, _opts) do
    if conn.assigns[:current_account] do
      conn
      |> redirect(to: ~p"/")
      |> halt()
    else
      conn
    end
  end

  def require_authenticated_account(conn, _opts) do
    if conn.assigns[:current_account] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to account this page.")
      |> redirect(to: ~p"/log_in")
      |> halt()
    end
  end

  def on_mount(:mount_current_account, _params, session, socket) do
    {:cont, mount_current_account(socket, session)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_account(socket, session)

    if socket.assigns.current_account do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to account this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/log_in")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_account_is_authenticated, _params, session, socket) do
    socket = mount_current_account(socket, session)

    if socket.assigns.current_account do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    else
      {:cont, socket}
    end
  end

  def mount_current_account(socket, session) do
    Phoenix.Component.assign_new(socket, :current_account, fn ->
      if account_token = session["account_token"] do
        Accounts.get_current_account(account_token)
      end
    end)
  end
end
