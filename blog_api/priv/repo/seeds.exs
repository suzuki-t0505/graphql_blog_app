alias BlogApi.Repo
alias BlogApi.Posts.Post

posts = [
  %Post{
    title: "投稿01",
    body: "これは投稿01です。\nこれは投稿01です。",
    type: 1
  },
  %Post{
    title: "投稿02",
    body: "これは投稿02です。\nこれは投稿02です。",
    type: 1
  },
  %Post{
    title: "投稿03",
    body: "これは投稿03です。\nこれは投稿03です。",
    type: 1
  }
]

Enum.each(posts, fn post -> Repo.insert!(post) end)
