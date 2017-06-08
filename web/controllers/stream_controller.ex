defmodule Forensic.StreamController do
  @moduledoc """
  Handles stream-related requests.
  """

  use Forensic.Web, :controller

  alias Forensic.Stream, as: S
  alias Forensic.Repo
  alias Forensic.Stage, as: Stg
  alias Forensic.StreamStage, as: SS
  alias Forensic.StageParam, as: SP

  @doc """
  List created streams.

  ## Parameters
      - conn: Related connection.

  ## Examples
      iex> build_conn() |> get(:index)
      {:ok, 200}
  """
  @spec index(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
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

    case Repo.insert(changeset) do
      {:ok, stream} ->
        S.add_stages(stream, Map.fetch(stream_params, :stages_ids))
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stream = S |> Repo.get(id) |> Repo.preload :stages
    stream_stages = Repo.all SS
    stream_params = (from u in SP, where: u.stream_id==^id, preload: :mirror) |> Repo.all
    render(conn, "show.html", %{stream: stream, stream_stages: stream_stages, stream_params: stream_params})
  end

  @doc """
  Flush Shock results.
  """
  def flush(conn, params) do
    KafkaEx.produce("new_pipeline_instruction", 0, "flush;{}")
    show(conn, params)
  end

  def update(conn, %{"id" => id, "stream" => stream_params}) do
    stream = Repo.get(S, id)
    changeset = S.changeset(stream, stream_params)
    case Repo.update(changeset) do
      {:ok, stream} ->
        S.add_stages(stream, Map.fetch(stream_params, :stages_ids))

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

  def edit_params(conn, %{"id" => id, "stage_id" => stage_id}) do
    stream = Repo.get S, id
    stage = Repo.get(Stg, stage_id) |> Repo.preload :params
    q = (from p in SP, where: p.stage_id==^stage.id and p.stream_id==^stream.id)
    params = Repo.all q
    render(conn, "edit_params.html", %{stream: stream, params: params, stage: stage})
  end

  def configure_param(conn, %{"id" => id, "stage_id" => stage_id, "param_id" => param_id, "stage_param" => stage_param}) do
    stage_param = Map.merge(%{"stage_id" => stage_id, "stream_id" => id, "mirror_id" => param_id}, stage_param)
    changeset = SP.changeset(%SP{}, stage_param)
    case Repo.insert(changeset) do
      {:ok, prms} ->
        edit_params(conn, %{"id" => id, "stage_id" => stage_id})

      {:error, changeset} ->
        edit_params(conn, %{"id" => id, "stage_id" => stage_id})
    end
  end

  def shock_injection(conn, %{"id" => id}) do
    stream = Repo.get(S, id) |> Repo.preload(:stages)
    injected? = stream.injected?
    if not injected? do
      S.shock_injection(stream)
    end
    changeset = S.changeset(stream, %{injected?: not injected?})
    case Repo.update changeset do
      {:ok, stream} ->
        conn
        |> put_flash(:info, "Stream updated!")
        |> show(%{"id" => stream.id})

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid attributes!")
        |> show(%{"id" => stream.id})
    end
  end

  def stream_creation(conn, %{"id" => id}) do
    stream = Repo.get(S, id)
    S.create_shock_stream(stream)
    show(conn, %{"id" => id})
  end

  def start_streaming(conn, %{"id" => id}) do
    stream = Repo.get(S, id)
    S.start_streaming(stream)
    show(conn, %{"id" => id})
  end

  def delete(conn, %{"id" => id}) do
    stream = Repo.get(S, id)
    Repo.delete stream
    index(conn, %{})
  end
end
