defmodule Forensic.Stage do
  use Forensic.Web, :model
  use Ecto.Schema

  alias Forensic.MirrorParam, as: MP

  schema "stages" do
    field :title, :string
    field :description, :string
    field :script, :string
    field :step, :string
    field :shock_identifier, :string
    has_many :params, MP
    many_to_many :streams, Forensic.Stream, join_through: Forensic.StreamStage

    timestamps()
  end

  def step_icons("store"), do: "download"
  def step_icons("ingestion"), do: "eyedropper"
  def step_icons("process"), do: "industry"
  def step_icons("publish"), do: "sitemap"
  def step_icons(icon), do: "download"

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:title, :description, :step, :shock_identifier, :script])
    |> validate_required([:title, :step, :shock_identifier])
    |> validate_length(:title, [min: 3, max: 120])
    |> validate_length(:description, [max: 2000])
    |> validate_length(:script, [max: 2000])
  end
end
