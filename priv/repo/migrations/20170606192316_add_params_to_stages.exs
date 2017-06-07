defmodule Forensic.Repo.Migrations.AddParamsToStages do
  use Ecto.Migration

  def change do
    create table(:stage_params) do
      add :stream_id, references(:streams, on_delete: :delete_all)
      add :stage_id, references(:stages, on_delete: :delete_all)
      timestamps()
    end

    create unique_index(:stage_params, [:stage_id])
    create unique_index(:stage_params, [:stream_id])
  end
end
