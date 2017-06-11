defmodule Forensic.MirrorParamController do
  use Forensic.Web, :controller

  alias Forensic.MirrorParam, as: MP

  def edit(conn, %{"stage_id" => stage_id, "id" => id}) do
    mp = MP |> Repo.get(id) |> Repo.preload(:stage)
    changeset = MP.changeset(mp, %{})
    render(conn, "edit.html", %{changeset: changeset, mp: mp})
  end

  def create(conn, %{"stage_id" => stage_id, "mirror_param" => mirror_param}) do
    prms = Map.merge(%{"stage_id" => stage_id}, mirror_param)
    changeset = MP.changeset(%MP{}, prms)
    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Param created!")
        |> redirect(to: stage_path(conn, :show, stage_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid param")
        |> redirect(to: stage_path(conn, :show, stage_id))
    end
  end

  def delete(conn, %{"stage_id" => stage_id, "id" => id}) do
    param = Repo.get(MP, id)
    Repo.delete param

    conn
    |> put_flash(:error, "Param destroy'd!")
    |> redirect(to: stage_path(conn, :show, stage_id))
  end

  def update(conn, %{"id" => id, "stage_id" => stage_id, "mirror_param" => params}) do
    mp = Repo.get(MP, id)
    changeset = mp |> MP.changeset(params)

    case Repo.update(changeset) do
      {:ok, mp} ->
        mp = Repo.preload(mp, :stage)
        conn
        |> put_flash(:info, "Stage updated!")
        |> redirect(to: stage_path(conn, :show, mp.stage.id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid attributes!")
        |> edit(%{"id" => id, "stage_id" => stage_id})
    end
  end
end
