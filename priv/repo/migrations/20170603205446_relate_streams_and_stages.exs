defmodule Forensic.Repo.Migrations.RelateStreamsAndStages do
  use Ecto.Migration

  def change do
    create table(:stages) do
      add :title, :string, null: false
      add :description, :text
      add :script, :text
      timestamps()
    end

    create table(:stream_stages, primary_key: false) do
      add :stream_id, references(:streams, on_delete: :delete_all)
      add :stage_id, references(:stages, on_delete: :delete_all)
      timestamps()
    end
    create unique_index(:stream_stages, [:stage_id, :stream_id])
  end
end
