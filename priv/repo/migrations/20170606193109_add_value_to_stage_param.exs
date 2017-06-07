defmodule Forensic.Repo.Migrations.AddValueToStageParam do
  use Ecto.Migration

  def change do
    alter table(:stage_params) do
      add :value, :string, default: ""
    end
  end
end
