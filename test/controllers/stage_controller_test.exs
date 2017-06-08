defmodule Forensic.StageControllerTest do
  use Forensic.ConnCase

  alias Forensic.Repo

  import Forensic.Factory

  def setup do
    {:ok, conn: build_conn()}
  end

  test "GET /stages", %{conn: conn} do
    insert(:stage)
    conn = get conn, "/stages"
    assert html_response(conn, 200) =~ "ingestion"
  end

  test "GET /stages/new", %{conn: conn} do
    conn = get conn, "/stages/new"
    assert html_response(conn, 200)
  end

  test "GET /stages/id", %{conn: conn} do
    stage = insert(:stage)
    conn = get conn, stage_path(conn, :show, stage.id)
    assert html_response(conn, 200)
  end

  test "GET /stages/id/edit", %{conn: conn} do
    stage = insert(:stage)
    conn = get conn, stage_path(conn, :edit, stage.id)
    assert html_response(conn, 200)
  end

  test "POST /stages", %{conn: conn} do
    params = params_for(:stage)
    conn = post conn, stage_path(conn, :create, %{"stage" => params})
    assert html_response(conn, 200)
  end
end
