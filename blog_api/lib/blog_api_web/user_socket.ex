defmodule BlogApiWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket,
    schema: BlogApiWeb.Schema

  alias BlogApi.Accounts

  def connect(%{"authorization" => "Bearer " <> token}, socket) do
    current_account = Accounts.get_account_by_session_token(token)
    socket = Absinthe.Phoenix.Socket.put_options(socket, context: %{current_account: current_account})

    {:ok, socket}
  end

  def connect(_params, _socket), do: :error

  def id(_socket), do: nil
end
