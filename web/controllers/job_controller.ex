defmodule Forensic.JobController do
  use Forensic.Web, :controller

  alias Forensic.Job

  def parse_publish_strategy(opts) do
    name = Map.fetch!(opts, "name")
    parse_strategy(name, opts)
  end

  def parse_strategy("hdfs", opts) do
    path = Map.fetch!(opts, "file_name")
    format = Map.fetch!(opts, "format")
    ["--publish", "hdfs", format, path]
  end

  def parse_strategy("test", opts) do
    {:test, opts}
  end

  def parse_strategy("console", opts) do
    ["--publish", "console"]
  end

  @required_attrs ["capabilities", "publish_strategy"]
  def missing_required_attrs(params) do
    @required_attrs
    |> Enum.map(&({&1, Map.fetch(params, &1)}))
    |> Enum.reduce({false, :empty}, &(_missing_required_attrs(&1, &2)))
  end
  def _missing_required_attrs({param, :error}, acc),
    do: {true, param}
  def _missing_required_attrs({param, query}, acc),
    do: acc

  def _run_job(params, conn) do
    capabilities_schema = params
                          |> Map.fetch!("capabilities")
                          |> Enum.map(&({&1, Map.fetch!(params, &1 <> "_schema")}))
                          |> Enum.reduce([], fn ({cap_title, cap_attrs}, acc) ->
                            acc ++ [cap_title <> "_schema", "#{Kernel.trunc(length(cap_attrs)/2)}" | cap_attrs]
                          end)

    if Map.fetch!(params, "publish_strategy")["name"] == "test" do
      test_job(conn)
    else
      publish_strategy_opts = parse_publish_strategy(Map.fetch!(params, "publish_strategy"))
      other_params = Map.fetch!(params, "others")

      job_name = Map.fetch!(params, "job")

      docker_arguments = [
        "exec",
        "-i", # exec mode
        "master", # container name
        "spark-submit",
        "/jobs/#{job_name}.py"] ++ publish_strategy_opts ++ capabilities_schema ++ ["--others"] ++ other_params

      log = System.cmd("docker", docker_arguments,  stderr_to_stdout: true)
      IO.inspect(log, printable_limit: :infinity)

      conn
      |> put_status(:created)
      |> json(%{})
    end
  end

  def test_job(conn) do
    conn
    |> put_status(:created)
    |> json(%{})
  end

  def run_job(conn, params) do
    case missing_required_attrs(params) do
      {false, :empty} ->
        _run_job(params, conn)
      {true, param} ->
        conn
        |> put_status(:bad_request)
        |> json(%{reason: "Missing required param `#{param}`"})
    end
  end
end
