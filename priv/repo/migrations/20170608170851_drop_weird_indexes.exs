defmodule Forensic.Repo.Migrations.DropWeirdIndexes do
  use Ecto.Migration

  def change do
    drop index(:mirror_params, [:stage_id])
  end
end
