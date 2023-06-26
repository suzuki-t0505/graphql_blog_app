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
end
