defmodule :"Elixir.Forensic.Repo.Migrations.TransformRequired?ToBoolean" do
  use Ecto.Migration

  def change do
    alter table(:mirror_params) do
      remove :required?
      add :required?, :boolean, default: :false
    end
  end
end
