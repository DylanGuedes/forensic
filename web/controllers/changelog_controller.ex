defmodule Forensic.ChangelogController do
  use Forensic.Web, :controller

  alias Forensic.Changelog

  def index(conn, _) do
    q = from p in Changelog
    changelogs = Repo.all q
    render conn, "index.html", changelogs: changelogs
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: Changelog.changeset(%Changelog{}, %{}))

  def create(conn, %{"changelog" => changelog_params}) do
    changeset = Changelog.changeset(%Changelog{}, changelog_params)

    case Repo.insert(changeset) do
      {:ok, changelog} ->
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end
end
