defmodule BlogApiWeb.Schema do
  use Absinthe.Schema

  alias BlogApi.Resolver

  import_types(BlogApi.Objects)

  object :account do
    field :id, :id
    field :email, :string
    field :confirmed_at, :datetime
    field :posts, list_of(:post)
  end

  object :auto_play_load do
    field :account, :account
    field :token, :string
  end

  query do
    import_fields :post_queries

    field :current_account, :account do
      resolve(&Resolver.Accounts.get_current_account/3)
    end
  end

  mutation do
    import_fields :post_mutations

    field :log_in_account, :auto_play_load do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve(&Resolver.Accounts.log_in_account/3)
    end

    field :register_account, :auto_play_load do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve(&Resolver.Accounts.register_account/3)
    end

    field :log_out_account, :string do
      resolve(&Resolver.Accounts.log_out_account/3)
    end
  end

  defp parse_datetime(data) do
    with {:ok, naive_datetime} <- Timex.parse(data, "{ISOdate} {ISOtime}"),
      datetime <- Timex.to_datetime(naive_datetime) do
        {:ok, datetime}
    else
      _ -> {:error, data}
    end
  end
end
