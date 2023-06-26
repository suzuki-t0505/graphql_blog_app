defmodule BlogApi.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false
      add :body, :text
      add :type, :integer, null: false
      add :submit_datetime, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
