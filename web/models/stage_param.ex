defmodule Forensic.StageParam do
  use Forensic.Web, :model
  use Ecto.Schema

  alias Forensic.Stage, as: Stg
  alias Forensic.Stream, as: S
  alias Forensic.StageParam, as: SP

  schema "stage_params" do
    belongs_to :stage, Stg
    belongs_to :stream, S

    timestamps()
  end

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:stage_id, :stream_id, :value])
    |> validate_required([:stage_id, :stream_id])
  end

  def build(stg_id, s_id, value) do
    SP.changeset(%SP{}, %{stage_id: stg_id, stream_id: s_id, value: value})
  end
end
