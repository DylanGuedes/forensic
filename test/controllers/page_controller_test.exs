defmodule Forensic.PageControllerTest do
  use Forensic.ConnCase

  def setup do
    {:ok, conn: build_conn()}
  end

  test "GET / should work fine", %{conn: conn} do
    conn = get(conn, page_path(conn, :index))
    assert html_response(conn, 200)
  end
end
