defmodule ElixirBlogApp.Accounts.Account do
  import Ecto.Changeset

  @types %{email: :string, password: :string}
  def changeset(data, params \\ %{}) do
    {data, @types}
    |> cast(params, [:email, :password])
    |> validate_required(:email, message: "Please enter your email.")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> validate_required(:password, message: "Please enter your password.")
    |> validate_length(:password, min: 12, max: 72)
  end
end
