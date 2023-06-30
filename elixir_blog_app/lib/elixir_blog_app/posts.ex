defmodule ElixirBlogApp.Posts do
  alias ElixirBlogApp.Posts.Post

  @base_url "http://localhost:4000/graphql"

  def list_posts() do
    %Req.Response{body: %{"data" => %{"posts" => posts}}} =
      Req.new(base_url: @base_url)
      |> AbsintheClient.attach()
      |> Req.post!(graphql: "query{posts{id title body type}}")
      
    posts
  end

  def create_post(attrs, token) do
    cs = Post.changeset(%{}, attrs)

    if cs.valid? do
      mutation =
        {
          "mutation($title: String! $body: String! $type: Int!)
          {createPost(title: $title body: $body type: $type){id title body type}}",
          cs.changes
        }

      %Req.Response{body: %{"data" => %{"createPost" => post}}} =
        Req.new(base_url: @base_url, headers: [{"authorization", token}])
        |> AbsintheClient.attach()
        |> Req.post!(graphql: mutation)

      if post, do: {:ok, post}, else: {:error, %{cs | action: :insert}}
    else
      {:error, %{cs | action: :insert}}
    end
  end

  def post_changeset(data, params \\ %{}) do
    Post.changeset(data, params)
  end
end
