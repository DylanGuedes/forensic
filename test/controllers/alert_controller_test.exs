defmodule Forensic.AlertControllerTest do
  use Forensic.ConnCase

  def setup do
    {:ok, conn: build_conn()}
  end

  test "GET /alerts", %{conn: conn} do
    conn = get(conn, "/alerts")
    assert html_response(conn, 200)
  end
end
