defmodule BlogApi.Resolver.Posts do
  alias BlogApi.Posts
  alias BlogApi.Posts.Post
  alias BlogApi.Accounts.Account

  def get_posts(_root, _args, _info) do
    {:ok, Posts.list_posts() |> Enum.sort(:desc)}
  end

  def get_post(_root, %{id: id}, _info) do
    case Posts.get_post(id) do
      nil ->
        {:error, "Could not get post."}

      %Post{} = post -> {:ok, post}
    end
  end

  def create_post(_root, args, %{context: %{current_account: %Account{id: id}}}) do
    args =  Map.put(args, :account_id, id)
    case Posts.create_post(args) do
      {:ok, post} ->
        Absinthe.Subscription.publish(
          BlogApiWeb.Endpoint,
          post,
          post_added: Map.get(args, :topic, "no")
        )

        {:ok, Posts.get_post(post.id)}

      {:error, _cs} ->
        {:error, "Could not create post."}
    end
  end

  def create_post(_root, _args, _info) do
    {:error, "invalid authorization token."}
  end

  def update_post(_root, %{id: id} = args, %{context: %{current_account: current_account}}) do
    with %Post{} = post <- Posts.get_post(id),
      true <- post.account_id == current_account.id,
      {:ok, post} <- Posts.update_post(post, args) do

        {:ok, post}
    else
      false -> {:error, "invalid authorization token."}
      _ ->  {:error, "Could not update post."}
    end
  end

  def update_post(_root, _args, _info) do
    {:error, "invalid authorization token."}
  end

  def delete_post(_root, %{id: id}, %{context: %{current_account: current_account}}) do
    with %Post{} = post <- Posts.get_post(id),
      true <- post.account_id == current_account.id,
      {:ok, post} <- Posts.delete_post(post) do
        {:ok, post}
    else
      false -> {:error, "invalid authorization token."}
      _ -> {:error, "Could not delete post."}
    end
  end

  def delete_post(_root, _args, _info) do
    {:error, "invalid authorization token."}
  end
end
