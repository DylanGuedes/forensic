defmodule Forensic.Repo.Migrations.AddMirrorToStageParam do
  use Ecto.Migration

  def change do
    alter table(:stage_params) do
      add :mirror_id, references(:mirror_params, on_delete: :delete_all)
    end

    create unique_index(:stage_params, [:mirror_id])
  end
end
