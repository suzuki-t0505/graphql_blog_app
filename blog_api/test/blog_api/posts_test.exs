defmodule BlogApi.PostsTest do
  use BlogApi.DataCase

  alias BlogApi.Posts

  describe "posts" do
    alias BlogApi.Posts.Post

    import BlogApi.PostsFixtures

    @invalid_attrs %{body: nil, title: nil, type: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{body: "some body", title: "some title", type: 42}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.body == "some body"
      assert post.title == "some title"
      assert post.type == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body", title: "some updated title", type: 43}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.body == "some updated body"
      assert post.title == "some updated title"
      assert post.type == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
