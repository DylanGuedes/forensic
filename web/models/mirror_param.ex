defmodule Forensic.MirrorParam do
  use Forensic.Web, :model
  use Ecto.Schema

  alias Forensic.Stage, as: Stg

  schema "mirror_params" do
    field :param_type, :string
    field :title, :string
    field :required?, :string
    belongs_to :stage, Stg

    timestamps()
  end

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:title, :param_type, :stage_id])
    |> validate_required([:title, :param_type, :stage_id])
  end
end
