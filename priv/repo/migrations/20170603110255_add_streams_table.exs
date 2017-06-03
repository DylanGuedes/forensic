defmodule Forensic.Repo.Migrations.AddStreamsTable do
  use Ecto.Migration

  def change do
    create table(:streams) do
      add :name, :string, null: false
      add :description, :text
      timestamps()
    end

    create unique_index(:streams, [:name])
  end
end
