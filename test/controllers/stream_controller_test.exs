defmodule Forensic.StreamControllerTest do
  use Forensic.ConnCase

  alias Forensic.Repo
  alias Forensic.Stage, as: Stg
  alias Forensic.Stream, as: S

  import Forensic.Factory

  def setup do
    {:ok, conn: build_conn()}
  end

  test "GET /streams", %{conn: conn} do
    insert(:stream)
    conn = get conn, "/streams"
    assert html_response(conn, 200)
  end

  test "GET /streams/new", %{conn: conn} do
    conn = get(conn, "/streams/new")
    assert html_response(conn, 200)
  end

  test "GET /streams/id", %{conn: conn} do
    stream = insert(:stream)
    conn = get(conn, stream_path(conn, :show, stream.id))
    assert html_response(conn, 200)
  end

  test "GET /streams/id/edit", %{conn: conn} do
    stream = insert(:stream)
    conn = get(conn, stream_path(conn, :edit, stream.id))
    assert html_response(conn, 200)
  end

  test "POST /streams with correct attrs", %{conn: conn} do
    l1 = (from u in S) |> Repo.all |> length
    params = params_for(:stream)
    conn = post(conn, stream_path(conn, :create, %{"stream" => params}))
    l2 = (from u in S) |> Repo.all |> length
    assert html_response(conn, 200)
    assert l2==(l1+1)
  end

  test "POST /streams with wrong attrs", %{conn: conn} do
    l1 = (from u in S) |> Repo.all |> length
    params = params_for(:stream, %{name: "aa"})
    conn = post(conn, stream_path(conn, :create, %{"stream" => params}))
    assert html_response(conn, 200)
    l2 = (from u in S) |> Repo.all |> length
    assert l2==(l1)
  end
end
