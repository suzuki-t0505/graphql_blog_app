defmodule ElixirBlogApp.Accounts do
  alias ElixirBlogApp.Accounts.Account
  @base_url "http://localhost:4000/graphql"

  @spec get_current_account(String.t()) :: map() | nil
  def get_current_account(token) do
    query = "query{current_account{id email}}"

    %Req.Response{body: %{"data" => %{"current_account" => current_account}}} =
      Req.new(base_url: @base_url, headers: [{"authorization", token}])
      |> AbsintheClient.attach()
      |> Req.post!(graphql: query)

    current_account
  end

  @spec create_account(map()) :: {:ok, map(), String.t()} | {:error, Ecto.Changeset.t()}
  def create_account(attrs) do
    cs = Account.changeset(%{}, attrs)
    if cs.valid? do
      mutation =
        {
          "mutation($email: String! $password: String!)
          {registerAccount(email: $email password: $password){id email}}",
          cs.changes
        }

      %Req.Response{body: %{"data" => %{"registerAccount" => account}}} =
        Req.new(base_url: @base_url)
        |> AbsintheClient.attach()
        |> Req.post!(graphql: mutation)

      if account, do: {:ok, account}, else: {:error, %{cs | action: :insert}}
    else
      {:error, %{cs | action: :insert}}
    end
  end

  @spec log_in_account(String.t(), String.t()) :: {:ok, map(), String.t()} | {:error, nil, nil}
  def log_in_account(email, password) do
    mutation =
      {
        "mutation($email: String! $password: String!)
        {logInAccount(email: $email password: $password){token account{id email}}}",
        %{email: email, password: password}
      }

    %Req.Response{body: %{"data" => %{"logInAccount" => log_in_account}}} =
      Req.new(base_url: @base_url)
      |> AbsintheClient.attach()
      |> Req.post!(graphql: mutation)

    if log_in_account, do: {:ok, log_in_account["account"], log_in_account["token"]}, else: {:error, nil, nil}
  end

  @spec log_out_account(String.t()) :: String.t()
  def log_out_account(token) do
    mutation = "mutation{logOutAccount}"

    %Req.Response{body: %{"data" => %{"logOutAccount" => message}}} =
      Req.new(base_url: @base_url, headers: [{"authorization", token}])
      |> AbsintheClient.attach()
      |> Req.post!(graphql: mutation)

    message
  end

  @spec account_changeset(map(), map()) :: Ecto.Changeset.t()
  def account_changeset(data, params \\ %{}) do
    Account.changeset(data, params)
  end
end
