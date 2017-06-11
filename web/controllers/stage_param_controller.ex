defmodule Forensic.StageParamController do
  use Forensic.Web, :controller

  alias Forensic.StageParam, as: SP
  alias Forensic.Stream, as: S
  alias Forensic.Stage, as: Stg
  alias Forensic.MirrorParam, as: MP

  def delete(conn, %{"stream_id" => stream_id, "id" => id}) do
    sp = SP |> Repo.get(id)
    Repo.delete(sp)

    conn
    |> put_flash(:info, "Param destroy'd")
    |> redirect(to: stream_path(conn, :show, stream_id))
  end

  def index(conn, %{"stream_id" => stream_id, "stage_id" => stage_id}) do
    stream = Repo.get S, stream_id
    stage = Repo.get(Stg, stage_id) |> Repo.preload :params
    q = (from p in SP, where: p.stage_id==^stage.id and p.stream_id==^stream.id)
    params = Repo.all q
    render(conn, "index.html", %{stream: stream, params: params, stage: stage})
  end

  def create(conn, %{"stream_id" => stream_id, "mirror_param_id" => mp_id, "stage_param" => stage_param}) do
    mp = Repo.get(MP, mp_id)
    stage_param = Map.merge(%{"stage_id" => mp.stage_id, "stream_id" => stream_id, "mirror_id" => mp_id}, stage_param)
    changeset = SP.changeset(%SP{}, stage_param)
    case Repo.insert(changeset) do
      {:ok, prms} ->
        conn
        |> index(%{"stream_id" => stream_id, "stage_id" => mp.stage_id})

      {:error, changeset} ->
        conn
        |> index(%{"stream_id" => stream_id, "stage_id" => mp.stage_id})
    end
  end

end
