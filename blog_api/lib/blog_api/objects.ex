defmodule BlogApi.Objects do
  use Absinthe.Schema.Notation
  use BlogApi.Objects.CustomType
  use BlogApi.Objects.Post
  use BlogApi.Objects.Account
end
