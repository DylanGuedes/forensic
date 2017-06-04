defmodule Forensic.StageController do
  use Forensic.Web, :controller

  def index(conn, _) do
    stages = Forensic.Repo.all Forensic.Stage, preload: Forensic.Stream
    render conn, "index.html", stages: stages
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: Forensic.Stage.changeset(%Forensic.Stage{}, %{}))

  def create(conn, %{"stage" => stage_params}) do
    changeset = Forensic.Stage.changeset(%Forensic.Stage{}, stage_params)

    case Forensic.Repo.insert(changeset) do
      {:ok, stage} ->
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stage = Repo.get(Forensic.Stage, id)
    render(conn, "show.html", stage: stage)
  end

  def delete(conn, %{"id" => id}) do
    stage = Repo.get(Forensic.Stage, id)
    Repo.delete stage
    index(conn, %{})
  end
end
