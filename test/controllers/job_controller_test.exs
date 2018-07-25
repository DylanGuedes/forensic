defmodule Forensic.JobControllerTest do
  use Forensic.ConnCase

  def setup do
    {:ok, conn: build_conn()}
  end

  test "submit a simple job with correct params", %{conn: conn} do
    params = %{
      "capabilities" => ["car_monitoring"],
      "car_monitoring_schema" => ["kmh", "double"],
      "publish_strategy" => %{"name": "test"}
    }

    conn = post(conn, job_path(conn, :run_job, params))
    assert json_response(conn, 201)
  end

  test "run job missing params", %{conn: conn} do
    params = %{
      "publish_strategy" => %{"name": "test"}
    }

    conn = post(conn, job_path(conn, :run_job, params))
    assert json_response(conn, 400)
  end
end
