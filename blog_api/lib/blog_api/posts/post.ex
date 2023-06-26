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
    |> cast(attrs, [:title, :body, :type, :submit_datetime])
    |> validate_post()
  end

  defp validate_post(cs) do
    cs =
      cs
      |> validate_required(:title)
      |> validate_required(:type)

    unless get_field(cs, :type, 0) == 0 do
      cs
      |> change(%{submit_datetime: DateTime.truncate(DateTime.utc_now(), :second)})
      |> validate_required(:body)
      |> validate_required(:submit_datetime)
    else
      cs
    end
  end
end
