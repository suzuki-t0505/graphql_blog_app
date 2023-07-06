defmodule BlogApi.Resolver.Accounts do
  alias BlogApi.Accounts
  alias BlogApi.Accounts.Account

  def get_current_account(_root, _args, %{context: %{current_account: %Account{id: id}}}) do
    {:ok, Accounts.get_account!(id)}
  end

  def get_current_account(_root, _args, _info) do
    {:error, "invalid authorization token."}
  end

  def log_in_account(_root, %{email: email, password: password}, %{context: %{}}) do
    case Accounts.get_account_by_email_and_password(email, password) do
      nil ->
        {:error, "no account"}

      %Account{} = account ->
        token = Accounts.generate_account_session_token(account)
        {:ok, %{account: account, token: token}}
    end
  end

  def register_account(_root, args, _info) do
    case Accounts.register_account(args) do
      {:ok, %Account{} = account} ->
        {:ok, account}

      {:error, _cs} ->
        {:error, "Could not register account. "}
    end
  end

  # def log_out_account(_root, _args, %{context: %{token: token}}) do
  #   Accounts.delete_account_session_token(token)
  #   {:ok, "log out account"}
  # end

  # def log_out_account(_root, _args, _info) do
  #   {:error, "invalid authorization token."}
  # end

  def log_out_account(_root, _args, %{context: context}) do
    token = Map.get(context, :token, "")
    Accounts.delete_account_session_token(token)
    {:ok, "log out account"}
  end
end
