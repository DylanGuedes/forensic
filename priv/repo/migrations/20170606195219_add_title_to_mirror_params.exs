defmodule Forensic.Repo.Migrations.AddTitleToMirrorParams do
  use Ecto.Migration

  def change do
    alter table(:mirror_params) do
      add :title, :string
    end
  end
end
