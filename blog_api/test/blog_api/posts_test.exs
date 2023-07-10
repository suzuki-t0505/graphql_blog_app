defmodule BlogApi.PostsTest do
  use BlogApi.DataCase

  import BlogApi.PostsFixtures
  import BlogApi.AccountsFixtures

  alias BlogApi.Posts
  alias BlogApi.Repo

  setup do
    account = account_fixture()
    %{account: account}
  end

  describe "posts/0" do
    test "list_posts/0 returns all posts", %{account: %{id: account_id}} do
      posts =
        Enum.map(~w(test01 test02 test03),
          fn title -> Repo.preload(post_fixture(%{title: title, account_id: account_id}), :account)
        end)

      assert Posts.list_posts() == posts
    end

    test "list_posts/0 returns no posts" do
      assert Posts.list_posts() == []
    end
  end

  describe "get_post/1" do
    setup %{account: %{id: account_id}} do
      post = Repo.preload(post_fixture(%{account_id: account_id}), :account)
      %{post: post}
    end

    test "get_post/1 returns post", %{post: post} do
      assert Posts.get_post(post.id) == post
    end

    test "get_post/1 return no post" do
      assert Posts.get_post(0) == nil
    end
  end

  describe "create_post/1" do
    test "create_post/1 returns {:ok, post}", %{account: %{id: account_id}} do
      assert {:ok, post} = Posts.create_post(%{title: "test", body: "test", type: 1, account_id: account_id})
      assert %Posts.Post{title: "test", body: "test", type: 1, account_id: ^account_id} = post
    end

    test "create_post/1 return {:error, cs}" do
      assert {:error, %{valid?: false}} = Posts.create_post()
    end
  end

  describe "update_post/2" do
    setup %{account: %{id: account_id}} do
      post = post_fixture(%{account_id: account_id})
      %{post: post}
    end

    test "update_post/2 returns {:ok, post}", %{post: %{id: post_id} = post} do
      assert {:ok, %{id: ^post_id} = update_post} = Posts.update_post(post, %{title: "change title", body: "change body", type: 2})
      assert %Posts.Post{title: "change title", body: "change body", type: 2, id: ^post_id} = update_post
    end

    test "update_post/2 returns {:error, cs}", %{post: post} do
      assert {:error, %{valid?: false}} = Posts.update_post(post, %{title: ""})
    end
  end

  describe "delete_post/1" do
    setup %{account: %{id: account_id}} do
      post = post_fixture(%{account_id: account_id})
      %{post: post}
    end

    test "delete_post/1 returns {:ok, post}", %{post: %{id: post_id} = post} do
      assert {:ok, %{id: ^post_id}} = Posts.delete_post(post)
    end
  end
end
