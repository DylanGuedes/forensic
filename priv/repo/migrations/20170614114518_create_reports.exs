defmodule Forensic.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :uuid, :string
      add :value, :string
      add :capability, :string

      timestamps()
    end
  end
end
