defmodule Forensic.ChangelogController do
  use Forensic.Web, :controller

  alias Forensic.Changelog

  @deprecated "This endpoint will be removed."
  def index(conn, _) do
    changelogs = Changelog.all
    render conn, "index.html", changelogs: changelogs
  end

  @deprecated "This endpoint will be removed."
  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: Changelog.build)

  @deprecated "This endpoint will be removed."
  def create(conn, %{"changelog" => changelog_params}) do
    changeset = Changelog.build(changelog_params)

    case Changelog.save(changeset) do
      {:ok, changelog} ->
        index(conn, %{})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end
end
