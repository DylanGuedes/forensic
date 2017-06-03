defmodule Forensic.StreamStage do
  @moduledoc """
  * Entity take handles the relation between Stream and Stage

  ## Usage
      iex> args = %{stage_id: 1, stream_id: 1}
      iex> Forensic.StreamStage.changeset(%Forensic.StreamStage{}, args)
      %Forensic.StreamStage{}

  ## Attributes
      * stage_id: Id of the stage of the relationship
      * stream_id: Id of the stream of the relationship

  """

  use Ecto.Schema

  alias Ecto.Changeset

  @typedoc """
  StreamStage struct

  ## Attributes
      * stream_id
      * stage_id
  """
  @type t :: %Forensic.StreamStage{}

  @primary_key false
  schema "stream_stages" do
    belongs_to :stage, Forensic.Stage
    belongs_to :stream, Forensic.Stream

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ %{}) do
    struct
    |> Changeset.cast(params, [:stream_id, :stage_id])
    |> Changeset.validate_required([:stream_id, :stage_id])
  end

  @spec relate(integer, integer) :: Ecto.Changeset.t
  def relate(stage_id, stream_id) do
    Forensic.StreamStage.changeset(%Forensic.StreamStage{}, %{
      stream_id: stream_id,
      stage_id: stage_id
    })
  end
end
