defmodule Forensic.AlertController do
  use Forensic.Web, :controller

  alias Forensic.Report, as: R
  alias Forensic.Stream, as: S

  @deprecated "This endpoint will be removed."
  def index(conn, _params) do
    reports = Forensic.Report.all
    render(conn, "index.html", %{reports: reports})
  end

  @deprecated "This endpoint will be removed."
  def avg(conn, _params) do
    render(conn, "avg.html")
  end

  @deprecated "This endpoint will be removed."
  def flush_avg(conn, _params) do
    S.flush(%{path: "/avg", strategy: "queryAndServeWebsockets", query: "select * from avg", event: "new_avg"})
    json conn, %{status: 200}
  end
end
