defmodule Forensic.AlertController do
  use Forensic.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
