defmodule Forensic.StageParamController do
  use Forensic.Web, :controller

  alias Forensic.StageParam, as: SP

  def delete_entity(conn, %{"id" => id}) do
    sp = SP |> Repo.get(id) |> Repo.preload(:stream)
    stream = sp.stream
    Repo.delete(sp)

    conn
    |> put_flash(:info, "Param destroy'd")
    |> redirect(to: stream_path(conn, :show, sp.stream.id))
  end
end
