defmodule Forensic.StreamController do
  use Forensic.Web, :controller

  alias Forensic.Stream, as: S
  alias Forensic.Repo
  alias Forensic.Stage, as: Stg
  alias Forensic.StreamStage, as: SS

  def index(conn, _params) do
    q = from p in S
    streams = Repo.all q
    render conn, "index.html", streams: streams
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", %{changeset: changeset, stages: Repo.all Stg})
  def new(conn, _params),
    do: new(conn, changeset: S.changeset(%S{}, %{}))

  def create(conn, %{"stream" => stream_params}) do
    changeset = S.changeset(%S{}, stream_params)
    stages = Map.fetch(stream_params, :stages_ids)
    IO.inspect stages

    case Repo.insert(changeset) do
      {:ok, stream} ->
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stream = S |> Repo.get(id) |> Repo.preload :stages
    stream_stages = Repo.all SS
    render(conn, "show.html", %{stream: stream, stream_stages: stream_stages})
  end

  def flush(conn, params) do
    KafkaEx.produce("new_pipeline_instruction", 0, "flush;{}")
    show(conn, params)
  end

  def update(conn, %{"id" => id, "stream" => stream_params}) do
    stream = Repo.get(S, id)
    params =
      case Map.has_key?(stream_params, :stages_ids) do
        true ->
          stream_params
        false ->
          Map.merge(%{"stages_ids" => []}, stream_params)
      end

    changeset = S.changeset(stream, params)
    IO.puts "params => "
    IO.inspect params

    case Repo.update(changeset) do
      {:ok, stream} ->
        for stage_id <- params["stages_ids"] do
          stream_stage = SS.relate(stage_id, stream.id)
          {:ok, _} = Repo.insert(stream_stage)
        end

        conn
        |> put_flash(:info, "Stream updated!")
        |> show(%{"id" => stream.id})

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid attributes!")
        |> edit(changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    case Repo.get(S, id) do
      stream when is_map(stream) ->
        changeset = S.changeset(stream, %{})
        stages = Repo.all Stg
        render(conn, "edit.html", %{changeset: changeset, stream: stream, stages: stages})
      _ ->
        show(conn, %{"id" => id})
    end
  end
end
