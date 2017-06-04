defmodule Forensic.Repo.Migrations.AddStepToStage do
  use Ecto.Migration

  def change do
    alter table(:stages) do
      add :step, :string, default: false
    end
  end
end
