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
  alias Forensic.Stream, as: S
  alias Forensic.StreamStage, as: SS

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
    field :created?, :boolean
    many_to_many :stages, Forensic.Stage, join_through: Forensic.StreamStage

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :created?, :injected?, :description])
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
      selected_params =
        (from p in SP, where: p.stage_id==^p.id and p.stream_id==^stream.id, preload: :mirror)
        |> Repo.all

      selected_params = Enum.reduce(selected_params, %{}, fn(param, acc) ->
        Enum.into(%{"#{param.mirror.title}" => param.value}, acc) end)

      selected_params = Map.merge(selected_params, %{
        "shock_action" => p.shock_identifier, "stream" => String.replace(stream.name, " ", "")
      })

      args = Poison.encode!(selected_params)
      KafkaEx.produce("new_pipeline_instruction", 0, file <> args)
    end
  end

  def kafka_create_stream(stream) do
    args = %{"stream" => String.replace(stream.name, " ", "")} |> Poison.encode!
    payload = "newStream;"<>args
    KafkaEx.produce("new_pipeline_instruction", 0, payload)
    toggle_created_attr(stream)
  end

  @doc """
  Toggle the boolean value of the `created?` attr.

  ## Parameters
      - stream : Related stream.
  
  ## Examples
      iex> stream = Repo.get(Forensic.Stream, 1)
      iex> stream.created?
      false
      iex> Forensic.Stream.toggle_created_attr(stream)
      :ok
      iex> stream = Repo.get(Forensic.Stream, 1)
      iex> stream.created?
      true 
  """
  @spec toggle_created_attr(t) :: :ok
  def toggle_created_attr(stream) do
    changeset = S.changeset(stream, %{"created?" => not stream.created?})
    Repo.update changeset
    :ok
  end

  @doc """
  Creates Shock stream.

  If the stream is already created, it is destroyed.

  ## Parameters
      - stream : Related stream.

  ## Examples
      iex> stream = Repo.get(Forensic.Stream, 1)
      iex> Forensic.Stream.create_shock_stream(stream)
      => Kafka's message sent
  """
  @spec create_shock_stream(t) :: atom
  def create_shock_stream(stream) do
    created? = stream.created?
    case created? do
      true ->
        toggle_created_attr(stream)
      false ->
        kafka_create_stream(stream)
    end
  end

  @doc """
  Tells Shock to start the streaming.

  ## Parameters
      - stream: Stream that will be started.

  ## Examples
      iex> stream = Repo.get(Forensic.Stream, 1)
      Forensic.Stream{...}
      iex> Forensic.Stream.start_streaming(stream)
      => Kafka's message sent
  """
  @spec start_streaming(t) :: :ok
  def start_streaming(stream) do
    payload = %{"stream" => String.replace(stream.name, " ", "")} |> Poison.encode!
    KafkaEx.produce("new_pipeline_instruction", 0, "start;"<>payload)
    :ok
  end

  @doc """
  Relate every stage_id with the given stream.

  ## Parameters
      - stream: A stream already inserted in the Repo.
      - stages_ids: List of stages that will be related.


  ## Examples
      iex> length(Repo.all(Forensic.StreamStage))
      0
      iex> Forensic.Stream.add_stages(stream, [1,2,3])
      :ok
      iex> length(Repo.all(Forensic.StreamStage))
      3
  """
  @spec add_stages(t, :error) :: nil
  def add_stages(stream, :error), do: :nil
  @spec add_stages(t, List.t) :: :ok
  def add_stages(stream, stages_ids) do
    for stage_id <- stages_ids do
      stream_stage = SS.relate(stage_id, stream.id)
      {:ok, _} = Repo.insert(stream_stage)
    end
    :ok
  end
end
