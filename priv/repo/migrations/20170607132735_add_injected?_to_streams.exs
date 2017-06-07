defmodule :"Elixir.Forensic.Repo.Migrations.AddInjected?ToStreams" do
  use Ecto.Migration

  def change do
    alter table(:streams) do
      add :injected?, :boolean, default: :false
    end
  end
end
