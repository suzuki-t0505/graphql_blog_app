defmodule BlogApiWeb.Schema do
  use Absinthe.Schema

  import_types(BlogApi.Objects)

  query do
    import_fields :post_queries
    import_fields :account_queries
  end

  mutation do
    import_fields :post_mutations
    import_fields :account_mutations
  end

  subscription do
    field :post_added, :post do
      arg :topic, non_null(:string)

      config fn args, _ ->
        {:ok, topic: args.topic}
      end

      trigger :create_post, topic: fn post ->
        post.title
      end

      resolve fn post, _t, _a ->
        {:ok, BlogApi.Posts.get_post(post.id)}
      end
    end
  end
end
