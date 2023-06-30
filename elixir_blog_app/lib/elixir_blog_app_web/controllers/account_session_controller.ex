defmodule ElixirBlogAppWeb.AccountSessionController do
  use ElixirBlogAppWeb, :controller

  alias ElixirBlogAppWeb.AccountAuth
  alias ElixirBlogApp.Accounts

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back")
  end

  defp create(conn, %{"account" => %{"email" => email, "password" => password}}, info) do
    case Accounts.log_in_account(email, password) do
      {:ok, _account, token} ->
        # 認証できた場合
        conn
        |> put_flash(:info, info)
        |> AccountAuth.log_in_account(token)

      {:error, nil, nil} ->
        # 認証できなかった場合
        conn
        |> put_flash(:error, "Invalid email or password")
        |> put_flash(:email, String.slice(email, 0, 160))
        |> redirect(to: ~p"/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> AccountAuth.log_out_account()
  end
end
