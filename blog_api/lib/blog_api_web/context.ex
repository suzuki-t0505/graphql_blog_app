defmodule BlogApiWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias BlogApi.Accounts
  alias BlogApi.Accounts.Account

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    # %Plug.Connに%{context: context}を登録する
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    # %Plug.Connのreq_headersから"authorization"の値を取り出す
    # リクエストを送る際はヘッダー(authorization)も一緒に送る必要がある
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, %Account{} = account} <- authorize(token) do
        %{current_account: account, token: token}
      else
        _ -> %{}
    end
  end

  defp authorize(token) do
    case Accounts.get_account_by_session_token(token) do
      nil -> {:error, "invalid authorization token."}
      %Account{} = account -> {:ok, account}
    end
  end
end
