defmodule Forensic.StreamController do
  use Forensic.Web, :controller

  alias Forensic.Stream

  def index(conn, _params) do
    q = from p in Stream
    streams = Repo.all q
    IO.inspect streams
    render conn, "index.html", streams: streams
  end
end
