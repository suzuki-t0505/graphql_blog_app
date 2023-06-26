defmodule BlogApi.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :title, :string
    field :type, :integer, default: 1
    field :submit_datetime, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :type, :submit_date])
    |> validate_required([:title, :body, :type])
  end
end
