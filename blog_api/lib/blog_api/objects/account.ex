defmodule BlogApi.Objects.Account do
  alias BlogApi.Resolver
  defmacro __using__(_) do
    quote do
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

      object :account_queries do
        field :current_account, :account do
          resolve(&Resolver.Accounts.get_current_account/3)
        end
      end

      object :account_mutations do
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
    end
  end
end
