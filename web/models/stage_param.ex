defmodule Forensic.StageParam do
  use Forensic.Web, :model
  use Ecto.Schema

  alias Forensic.Stage, as: Stg
  alias Forensic.Stream, as: S
  alias Forensic.StageParam, as: SP
  alias Forensic.MirrorParam, as: MP

  schema "stage_params" do
    belongs_to :stage, Stg
    belongs_to :stream, S
    belongs_to :mirror, MP
    field :value, :string

    timestamps()
  end

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:stage_id, :mirror_id, :stream_id, :value])
    |> validate_required([:stage_id, :mirror_id ,:stream_id, :value])
  end

  def build(mirror_id, stg_id, s_id) do
    SP.changeset(%SP{}, %{mirror_id: mirror_id, stage_id: stg_id, stream_id: s_id})
  end
end
