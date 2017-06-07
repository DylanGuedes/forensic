defmodule Forensic.Repo.Migrations.CreateMirrorParams do
  use Ecto.Migration

  def change do
    create table(:mirror_params) do
      add :stage_id, references(:stages, on_delete: :delete_all)
      add :param_type, :string

      timestamps()
    end

    create unique_index(:mirror_params, [:stage_id])
  end
end
