defmodule Forensic.MirrorParamControllerTest do
  use Forensic.ConnCase

  import Forensic.Factory
  alias Forensic.MirrorParam, as: MP

  def setup do
    {:ok, conn: build_conn()}
  end

  test "GET /stages/:stage_id/mirror_params", %{conn: conn} do
    stage = insert(:stage)
    mp = insert(:mirror_param, %{stage: stage})
    conn = get conn, stage_mirror_param_path(conn, :edit, stage.id, mp.id)
    assert html_response(conn, 200)
  end

  test "POST /stages/:stage_id/mirror_params with correct params", %{conn: conn} do
    stage = insert(:stage)
    params = params_for(:mirror_param)
    l1 = MP |> Repo.all |> length
    conn = post conn, stage_mirror_param_path(conn, :create, stage.id, %{"mirror_param" => params})
    l2 = MP |> Repo.all |> length
    assert l1+1==l2
  end

  test "POST /stages/:stage_id/mirror_params with incorrect params", %{conn: conn} do
    stage = insert(:stage)
    params = %{"param_type" => "string"}
    l1 = MP |> Repo.all |> length
    conn = post conn, stage_mirror_param_path(conn, :create, stage.id, %{"mirror_param" => params})
    l2 = MP |> Repo.all |> length
    assert l1==l2
  end

  test "GET /stages/:stage_id/mirror_params/:id/delete", %{conn: conn} do
    stage = insert(:stage)
    mp = insert(:mirror_param)
    l1 = MP |> Repo.all |> length
    conn = get conn, stage_mirror_param_path(conn, :delete, stage.id, mp.id)
    l2 = MP |> Repo.all |> length
    assert l1-1==l2
  end

  test "PATCH /stages/:stage_id/mirror_params/:id with correct params", %{conn: conn} do
    stage = insert(:stage)
    mp = insert(:mirror_param, %{stage: stage})
    mp = MP |> Repo.get(mp.id)
    t1 = mp.title
    params = params_for(:mirror_param, %{title: "besttitleever"})
    conn = patch conn, stage_mirror_param_path(conn, :update, stage.id, mp.id, %{"mirror_param" => params})
    mp = MP |> Repo.get(mp.id)
    t2 = mp.title
    refute t1 == t2
  end

  test "PATCH /stages/:stage_id/mirror_params/:id with wrong params", %{conn: conn} do
    stage = insert(:stage)
    mp = insert(:mirror_param, %{stage: stage})
    mp = MP |> Repo.get(mp.id)
    t1 = mp.title
    params = params_for(:mirror_param, %{title: ""})
    conn = patch conn, stage_mirror_param_path(conn, :update, stage.id, mp.id, %{"mirror_param" => params})
    mp = MP |> Repo.get(mp.id)
    t2 = mp.title
    assert t1 == t2
  end
end
