defmodule Forensic.MirrorParamController do
  use Forensic.Web, :controller

  alias Forensic.MirrorParam, as: MP

  def edit(conn, %{"id" => id}) do
    mp = MP |> Repo.get(id) |> Repo.preload(:stage)
    changeset = MP.changeset(mp, %{})
    render(conn, "edit.html", %{changeset: changeset, mp: mp})
  end

  def update(conn, %{"id" => id, "mirror_param" => params}) do
    changeset = MP |> Repo.get(id) |> MP.changeset(params)

    case Repo.update(changeset) do
      {:ok, mp} ->
        mp = Repo.preload(mp, :stage)
        conn
        |> put_flash(:info, "Stage updated!")
        |> redirect(to: stage_path(conn, :show, mp.stage.id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid attributes!")
        |> edit(%{"id" => id, changeset: changeset})
    end
  end
end
