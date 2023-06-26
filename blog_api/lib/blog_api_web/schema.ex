defmodule BlogApiWeb.Schema do
  use Absinthe.Schema

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
      resolve(fn _, _, _ -> {:ok, BlogApi.Posts.list_posts} end)
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
