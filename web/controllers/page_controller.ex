defmodule Forensic.PageController do
  use Forensic.Web, :controller

  def index(conn, _params) do
    streams = (from u in Forensic.Stream) |> Repo.all
    stages = (from u in Forensic.Stage) |> Repo.all
    render(conn, "index.html", %{stages: stages, streams: streams})
  end
end
