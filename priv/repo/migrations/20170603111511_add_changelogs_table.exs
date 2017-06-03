defmodule Forensic.Repo.Migrations.AddChangelogsTable do
  use Ecto.Migration

  def change do
    create table(:changelogs) do
      add :description, :text
      timestamps()
    end
  end
end
