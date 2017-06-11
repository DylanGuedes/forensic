defmodule Forensic.StageTest do
  use Forensic.ModelCase

  import Forensic.Factory

  alias Forensic.Stream, as: S
  alias Forensic.Stage, as: Stg
  alias Forensic.StreamStage, as: SS
  alias Forensic.StageParam, as: SP

  test "should work for valid attrs" do
    changeset = Stg.changeset(%Stg{}, params_for(:stage))
    assert changeset.valid?
  end

  test "#has_mirror_params? should return true" do
    stage = insert(:stage)
    mp = insert(:mirror_param, %{stage: stage})
    result = Stg.has_mirror_params?(stage.id)
    assert result == true
  end
end
