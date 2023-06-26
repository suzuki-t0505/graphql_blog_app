defmodule BlogApi.Objects.Post do
  alias BlogApi.Resolver
  defmacro __using__(_) do
    quote do
      object :post do
        field :id, :id
        field :title, :string
        field :body, :string
        field :type, :integer
        field :submit_datetime, :datetime
      end

      object :post_queries do
        field :posts, list_of(:post) do
          resolve(&Resolver.Posts.get_posts/3)
        end

        field :post, :post do
          arg :id, non_null(:id)
          resolve(&Resolver.Posts.get_post/3)
        end
      end

      object :post_mutations do
        field :create_post, :post do
          arg :title, non_null(:string)
          arg :body, :string
          arg :type, non_null(:integer)
          resolve(&Resolver.Posts.create_post/3)
        end

        field :update_post, :post do
          arg :id, non_null(:id)
          arg :title, non_null(:string)
          arg :body, :string
          arg :type, non_null(:integer)
          resolve(&Resolver.Posts.update_post/3)
        end

        field :delete_post, :post do
          arg :id, non_null(:id)
          resolve(&Resolver.Posts.delete_post/3)
        end
      end
    end
  end
end
