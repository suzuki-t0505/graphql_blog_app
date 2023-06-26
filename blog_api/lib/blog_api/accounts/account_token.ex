defmodule BlogApi.Accounts.AccountToken do
  use Ecto.Schema
  import Ecto.Query
  alias BlogApi.Accounts.Account

  @hash_algorithm :sha256
  @rand_size 32

  # It is very important to keep the reset password token expiry short,
  # since someone with access to the email may take over the account.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  schema "accounts_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :account, Account

    timestamps(updated_at: false)
  end

  def build_session_token(account) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %__MODULE__{token: token, context: "session", account_id: account.id}}
  end

  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: account in assoc(token, :account),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: account

    {:ok, query}
  end

  def build_email_token(account, context) do
    build_hashed_token(account, context, account.email)
  end

  defp build_hashed_token(account, context, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %__MODULE__{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       account_id: account.id
     }}
  end

  def verify_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
        days = days_for_context(context)

        query =
          from token in token_and_context_query(hashed_token, context),
            join: account in assoc(token, :account),
            where: token.inserted_at > ago(^days, "day") and token.sent_to == account.email,
            select: account

        {:ok, query}

      :error ->
        :error
    end
  end

  defp days_for_context("confirm"), do: @confirm_validity_in_days
  defp days_for_context("reset_password"), do: @reset_password_validity_in_days

  def verify_change_email_token_query(token, "change:" <> _ = context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

        query =
          from token in token_and_context_query(hashed_token, context),
            where: token.inserted_at > ago(@change_email_validity_in_days, "day")

        {:ok, query}

      :error ->
        :error
    end
  end

  def token_and_context_query(token, context) do
    from __MODULE__, where: [token: ^token, context: ^context]
  end

  def account_and_contexts_query(account, :all) do
    from t in __MODULE__, where: t.account_id == ^account.id
  end

  def account_and_contexts_query(account, [_ | _] = contexts) do
    from t in __MODULE__, where: t.account_id == ^account.id and t.context in ^contexts
  end
end
