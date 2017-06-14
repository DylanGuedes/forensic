defmodule Forensic.Report do
  use Forensic.Web, :model
  use Ecto.Schema

  schema "reports" do
    field :uuid, :string
    field :value, :string
    field :capability, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uuid, :value, :capability])
  end
end
