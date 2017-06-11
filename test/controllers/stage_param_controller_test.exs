defmodule Forensic.StageParamControllerTest do
  use Forensic.ConnCase

  import Forensic.Factory

  alias Forensic.StreamStage, as: SS
  alias Forensic.StageParam, as: SP

  def setup do
    {:ok, conn: build_conn()}
  end

  test "GET /streams/:stream_id/stages/:stage_id/stage_params", %{conn: conn} do
    stream = insert(:stream)
    stage = insert(:stage)
    SS.relate(stage.id, stream.id) |> Repo.insert
    insert(:mirror_param, %{stage: stage})
    conn = get conn, stream_stage_param_path(conn, :index, stream.id, stage.id)
    assert html_response(conn, 200)
  end

  test "POST /streams/:stream_id/stage_params", %{conn: conn} do
    stream = insert(:stream)
    stage = insert(:stage)
    SS.relate(stage.id, stream.id) |> Repo.insert
    mp = insert(:mirror_param, %{stage: stage})
    params = %{"value" => "nicevalue"}
    l1 = Repo.all(SP) |> length
    conn = post conn, stream_stage_param_path(conn, :create, stream.id, mp.id, %{"stage_param" => params})
    l2 = Repo.all(SP) |> length
    assert l1+1==l2
  end
end
