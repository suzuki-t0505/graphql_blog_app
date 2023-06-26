alias BlogApi.Repo
alias BlogApi.Posts.Post
alias BlogApi.Accounts.Account

[user01, _user02, _user03] =
  Enum.map(~w(user01 user02 user03), fn name ->
    Repo.insert!(
      %Account{
        email: name <> "@sample.com",
        hashed_password: Bcrypt.hash_pwd_salt(name <> "999"),
        confirmed_at: DateTime.truncate(DateTime.utc_now(), :second)
      }
    )
  end)

posts = [
  %Post{
    title: "投稿01",
    body: "これは投稿01です。\nこれは投稿01です。",
    type: 1,
    submit_datetime: DateTime.truncate(DateTime.utc_now(), :second)
  },
  %Post{
    title: "投稿02",
    body: "これは投稿02です。\nこれは投稿02です。",
    type: 1,
    submit_datetime: DateTime.truncate(DateTime.utc_now(), :second)
  },
  %Post{
    title: "投稿03",
    body: "これは投稿03です。\nこれは投稿03です。",
    type: 1,
    submit_datetime: DateTime.truncate(DateTime.utc_now(), :second)
  }
]

Enum.each(posts, fn post -> Repo.insert!(%{post | account_id: user01.id}) end)
