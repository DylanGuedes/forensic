defmodule Forensic.Resource do
  use Forensic.Web, :model

  schema "resources" do
    field :uuid, :string
    field :value, :string
    field :capability, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
  end

  def get_or_create(uuid) do
    q = (from u in Resource, where: u.uuid == ^uuid) |> Repo.all
    do_get_or_create(uuid, q)
  end

  defp do_get_or_create(uuid, []) do
    HTTPoison.get("http://localhost:3000/resources/"<>uuid)
  end
end
