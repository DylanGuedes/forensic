defmodule Forensic.MirrorParam do
  use Forensic.Web, :model
  use Ecto.Schema

  alias Forensic.Stage, as: Stg
  alias Forensic.StageParam, as: SP

  schema "mirror_params" do
    field :param_type, :string
    field :title, :string
    field :required?, :boolean
    belongs_to :stage, Stg
    has_many :params, SP

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :required?, :param_type, :stage_id])
    |> validate_required([:title, :param_type, :stage_id])
  end
end
