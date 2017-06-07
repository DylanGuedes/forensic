defmodule :"Elixir.Forensic.Repo.Migrations.AddRequired?ToMirrorParam" do
  use Ecto.Migration

  def change do
    alter table(:mirror_params) do
      add :required?, :string, default: false
    end
  end
end
