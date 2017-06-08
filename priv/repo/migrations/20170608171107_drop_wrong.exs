defmodule Forensic.Repo.Migrations.DropWrong do
  use Ecto.Migration

  def change do
    drop index(:stage_params, [:stage_id, :stream_id])
  end
end
