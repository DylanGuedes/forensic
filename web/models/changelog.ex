defmodule Forensic.Changelog do
  @moduledoc """
  * Entity that represents new Changelogs in the platform.

  ## Usage

      iex> Forensic.Changelog.changeset(%Forensic.Changelog, %{description: "My descript"})
      nil

  ## Attributes
      * description: Stream description
  """

  use Forensic.Web, :model
  use Ecto.Schema

  import Ecto.Changeset

  @typedoc """
  Changelog struct

  ## Attributes
      * description
  """
  @type t :: %Forensic.Changelog{}

  schema "changelogs" do
    field :description, :string

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:description])
    |> validate_required([:description])
    |> validate_length(:description, [max: 2000])
  end
end
