defmodule Forensic.AlertController do
  use Forensic.Web, :controller

  alias Forensic.Report, as: R

  def index(conn, _params) do
    reports = R |> Repo.all
    render(conn, "index.html", %{reports: reports})
  end
end
