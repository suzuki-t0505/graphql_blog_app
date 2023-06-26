defmodule BlogApiWeb.Schema do
  use Absinthe.Schema

  alias BlogApi.Resolver

  scalar :datetime do
    description "DateTime for 2022-03-01 00:00:00"
    parse &parse_datetime/1
    serialize &Calendar.strftime(&1, "%c")
  end

  object :post do
    field :id, :id
    field :title, :string
    field :body, :string
    field :type, :integer
    field :submit_datetime, :datetime
  end

  query do
    field :posts, list_of(:post) do
      resolve(&Resolver.Posts.get_posts/3)
    end
  end

  mutation do
    field :create_post, :post do
      arg :title, non_null(:string)
      arg :body, :string
      arg :type, non_null(:integer)
      resolve(&Resolver.Posts.create_posts/3)
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
