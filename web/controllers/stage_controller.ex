defmodule Forensic.StageController do
  use Forensic.Web, :controller

  alias Forensic.Stage, as: Stg
  alias Forensic.MirrorParam, as: MP

  @doc """
  List stages created.

  ## Parameters
      - conn: Connection

  ## Examples
      iex> build_conn |> get(:index)
      {:ok, 200}
  """
  @spec index(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def index(conn, _) do
    stages = Repo.all Stg, preload: Forensic.Stream
    render conn, "index.html", stages: stages
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: Stg.changeset(%Stg{}, %{}))

  def create(conn, %{"stage" => stage_params}) do
    changeset = Stg.changeset(%Stg{}, stage_params)

    case Forensic.Repo.insert(changeset) do
      {:ok, stage} ->
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stage = Repo.get(Stg, id) |> Repo.preload(:params)
    changeset = MP.changeset(%MP{})
    render(conn, "show.html", %{stage: stage, changeset: changeset})
  end

  def delete(conn, %{"id" => id}) do
    stage = Repo.get(Stg, id)
    Repo.delete stage
    index(conn, %{})
  end

  def edit(conn, %{"id" => id}) do
    case Repo.get(Stg, id) do
      stage when is_map(stage) ->
        changeset = Stg.changeset(stage, %{})
        render(conn, "edit.html", %{changeset: changeset, stage: stage})
      _ ->
        show(conn, %{"id" => id})
    end
  end

  def update(conn, %{"id" => id, "stage" => stage_params}) do
    stage = Repo.get(Stg, id)
    changeset = Stg.changeset(stage, stage_params)

    case Repo.update(changeset) do
      {:ok, stage} ->
        conn
        |> put_flash(:info, "Stage updated!")
        |> show(%{"id" => stage.id})

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid attributes!")
        |> edit(changeset: changeset)
    end
  end
end
