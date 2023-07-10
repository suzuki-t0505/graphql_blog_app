defmodule BlogApi.AccountsFixtures do
  alias BlogApi.Repo
  alias BlogApi.Accounts.{Account, AccountToken}

  def unique_account_email, do: "account#{System.unique_integer()}@example.com"
  def valid_account_password, do: "test999"

  def account_fixture(attrs \\ %{}) do
    email = Map.get(attrs, :email) || unique_account_email()
    hashed_password =
      Bcrypt.hash_pwd_salt(Map.get(attrs, :password) || valid_account_password())

    Repo.insert!(
      %Account{
        email: email,
        hashed_password: hashed_password,
        confirmed_at: DateTime.truncate(DateTime.utc_now(), :second)
      }
    )
  end

  def account_token_fixture(%{account_id: account_id} = attrs) do
    token = Map.get(attrs, :token) || :crypto.strong_rand_bytes(32)
    context = Map.get(attrs, :context) || "session"
    sent_to = Map.get(attrs, :sent_to)

    Repo.insert!(
      %AccountToken{
        token: token,
        context: context,
        sent_to: sent_to,
        account_id: account_id
      }
    )
  end
end
