defmodule Forensic.TaskController do
  use Forensic.Web, :controller

  alias Forensic.Stage, as: Stg
  alias Forensic.MirrorParam, as: MP

  def index(conn, _) do
    tasks = Repo.all Stg
    render(conn, "index.json", tasks: tasks)
  end
end
