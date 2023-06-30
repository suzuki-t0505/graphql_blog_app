defmodule ElixirBlogApp.Posts.Post do
  import Ecto.Changeset

  @types %{title: :string, body: :string, type: :integer}
  def changeset(data, params) do
    {data, @types}
    |> cast(params, [:title, :body, :type])
    |> validate_required([:title, :body, :type])
  end
end
