defmodule Forensic.ChangelogControllerTest do
  use Forensic.ConnCase
  import Forensic.Factory

  alias Forensic.Changelog, as: CL

  def setup do
    {:ok, conn: build_conn()}
  end

  test "GET /changelog/new", %{conn: conn} do
    conn = get(conn, changelog_path(conn, :new))
    assert html_response(conn, 200)
  end

  test "GET /changelog", %{conn: conn} do
    conn = get(conn, changelog_path(conn, :index))
    assert html_response(conn, 200)
  end

  test "POST /changelog", %{conn: conn} do
    l1 = (from p in CL) |> Repo.all |> length
    params = params_for(:changelog)
    conn = post(conn, changelog_path(conn, :create, %{"changelog" => params}))
    assert html_response(conn, 200)
    l2 = (from p in CL) |> Repo.all |> length
    assert l2==(l1+1)
  end
end
