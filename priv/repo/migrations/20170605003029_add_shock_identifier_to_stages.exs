defmodule Forensic.Repo.Migrations.AddShockIdentifierToStages do
  use Ecto.Migration

  def change do
    alter table(:stages) do
      add :shock_identifier, :string, default: false
    end
  end
end
