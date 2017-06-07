defmodule Forensic.Repo.Migrations.RemoveWeirdIndex do
  use Ecto.Migration

  def change do
    drop index(:stage_params, [:stage_id])
    drop index(:stage_params, [:stream_id])
    create unique_index(:stage_params, [:stage_id, :stream_id])
  end
end
