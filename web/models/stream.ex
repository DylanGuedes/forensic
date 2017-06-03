defmodule Forensic.Stream do
  @moduledoc """
  * Entity that represents Streams.

  ## Usage

      iex> Forensic.Stream.changeset(%Forensic.Stream, %{name: "My pipeline"})
      nil

  ## Attributes
      * name: Stream name
      * description: Stream description
  """

  use Forensic.Web, :model
  use Ecto.Schema

  import Ecto.Changeset

  @typedoc """
  Stream struct

  ## Attributes
      * name
      * description
  """
  @type t :: %Forensic.Stream{}

  schema "streams" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
    |> validate_length(:description, [max: 2000])
  end
end
