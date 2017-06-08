defmodule Forensic.Repo.Migrations.DropMirrorIdWrongIndex do
  use Ecto.Migration

  def change do
    drop index(:stage_params, [:mirror_id])
  end
end
