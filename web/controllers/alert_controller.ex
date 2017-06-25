defmodule Forensic.AlertController do
  use Forensic.Web, :controller

  alias Forensic.Report, as: R
  alias Forensic.Stream, as: S

  def index(conn, _params) do
    reports = R |> Repo.all
    render(conn, "index.html", %{reports: reports})
  end

  def avg(conn, _params) do
    render(conn, "avg.html")
  end

  def flush_avg(conn, _params) do
    S.flush(%{path: "/avg", strategy: "queryAndServeWebsockets", query: "select * from avg", event: "new_avg"})
    json conn, %{status: 200}
  end
end
