defmodule Forensic.Repo.Migrations.AddCreatedToStreams do
  use Ecto.Migration

  def change do
    alter table(:streams) do
      add :created?, :boolean, default: :false
    end
  end
end
