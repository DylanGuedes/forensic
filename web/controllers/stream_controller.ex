defmodule Forensic.StreamController do
  use Forensic.Web, :controller

  alias Forensic.Stream

  def index(conn, _params) do
    q = from p in Stream
    streams = Repo.all q
    IO.inspect streams
    render conn, "index.html", streams: streams
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: Stream.changeset(%Stream{}, %{}))

  def create(conn, %{"stream" => stream_params}) do
    changeset = Stream.changeset(%Stream{}, stream_params)

    case Repo.insert(changeset) do
      {:ok, stream} ->
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stream = Stream |> Repo.get(id)
    render(conn, "show.html", stream: stream)
  end
end
