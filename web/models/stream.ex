defmodule Forensic.Stream do
  @moduledoc """
  * Entity that represents Streams.

  ## Usage

      iex> Forensic.Stream.changeset(%Forensic.Stream, %{name: "My pipeline"})
      nil

  ## Attributes
      * name: Stream name
      * description: Stream description
  """

  use Forensic.Web, :model
  use Ecto.Schema

  alias Forensic.MirrorParam, as: MP
  alias Forensic.Repo
  alias Forensic.StageParam, as: SP

  import Ecto.Changeset

  @typedoc """
  Stream struct

  ## Attributes
      * name
      * description
  """
  @type t :: %Forensic.Stream{}

  schema "streams" do
    field :name, :string
    field :description, :string
    field :injected?, :boolean
    many_to_many :stages, Forensic.Stage, join_through: Forensic.StreamStage

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :injected?, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
    |> validate_length(:description, [max: 2000])
  end

  @spec shock_injection(t) :: t
  def shock_injection(stream) do
    stages = stream.stages
    stages_ids = stages |> Enum.map(fn (item) -> item.id end)
    selected_params = (from p in SP, where: p.stream_id == ^stream.id, preload: :stage) |> Repo.all
    for p <- stages do
      file = p.step <> ";"
      merged_params = %{}
      selected_params =
        (from p in SP, where: p.stage_id==^p.id and p.stream_id==^stream.id, preload: :mirror)
        |> Repo.all

      selected_params = Enum.reduce(selected_params, %{}, fn(param, acc) ->
        Enum.into(%{"#{param.mirror.title}" => param.value}, acc) end)

      args = Poison.encode!(selected_params)
      KafkaEx.produce("mypipeline", 0, file <> args)
    end
  end
end
