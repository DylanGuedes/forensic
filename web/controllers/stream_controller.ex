defmodule Forensic.StreamController do
  use Forensic.Web, :controller

  alias Forensic.Stream, as: S
  alias Forensic.Repo

  def index(conn, _params) do
    q = from p in S
    streams = Repo.all q
    IO.inspect streams
    render conn, "index.html", streams: streams
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: S.changeset(%S{}, %{}))

  def create(conn, %{"stream" => stream_params}) do
    changeset = S.changeset(%S{}, stream_params)

    case Repo.insert(changeset) do
      {:ok, stream} ->
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stream = S |> Repo.get(id)
    render(conn, "show.html", stream: stream)
  end

  def flush(conn, params) do
    # KafkaEx.produce("new_pipeline_instruction", 0, "flush;{}")
    show(conn, params)
  end
end
