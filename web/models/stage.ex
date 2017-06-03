defmodule Forensic.Stage do
  use Forensic.Web, :model
  use Ecto.Schema

  def changeset() do
  end

  schema "stages" do
    field :title, :string
    field :description, :string
    field :script, :string
    many_to_many :streams, Forensic.Stream, join_through: Forensic.StreamStage

    timestamps()
  end

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title, :script])
    |> validate_length(:title, [min: 3, max: 120])
    |> validate_length(:description, [max: 2000])
    |> validate_length(:script, [max: 2000])
  end
end
