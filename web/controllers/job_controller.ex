defmodule Forensic.JobController do
  use Forensic.Web, :controller

  alias Forensic.Job

  @spec index(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def index(conn, _) do
    jobs = File.ls! "./spark_jobs"
    render conn, "index.html", jobs: Enum.with_index(jobs)
  end

  def extract_capability_schema(params, capability) do
    Map.get(params, capability)
    |> List.flatten
  end

  def parse_publish_strategy(opts) do
    name = Map.fetch!(opts, "name")
    parse_strategy(name, opts)
  end

  def parse_strategy("hdfs", opts) do
    path = Map.fetch!(opts, "file_name")
    format = Map.fetch!(opts, "format")
    ["--publish", "hdfs", format, path]
  end

  def parse_strategy("console", opts) do
    ["--publish", "console"]
  end

  def run(conn, params) do
    capabilities_schema = params
                   |> Map.fetch!("capabilities")
                   |> Enum.map(&({&1, Map.fetch!(params, &1 <> "_schema")}))
                   |> Enum.reduce([], fn ({cap_title, cap_attrs}, acc) ->
                     acc ++ [cap_title <> "_schema", "#{Kernel.trunc(length(cap_attrs)/2)}" | cap_attrs]
                   end)

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
