defmodule Forensic.StreamTest do
  use Forensic.ModelCase

  import Forensic.Factory

  alias Forensic.Stream, as: S
  alias Forensic.StreamStage, as: SS

  @invalid1 %{name: "a", description: ""}
  @invalid2 %{name: String.duplicate("A", 121), description: "its nice rly"}

  test "should work for valid attrs" do
    changeset = S.changeset(%S{}, params_for(:stream))
    assert changeset.valid?
  end

  test "shouldnt work for invalid attrs" do
    lamb = fn (item) ->
      changeset = S.changeset(%S{}, item)
      refute changeset.valid?
    end

    [@invalid1, @invalid2]
    |> Enum.map(lamb)
  end

  test "associate with stage" do
    stream = insert(:stream, %{name: "nicename"})
    stage = insert(:stage)

    Repo.insert SS.relate(stage.id, stream.id)
    stream = Forensic.Repo.get(S, stream.id) |> Repo.preload(:stages)
    assert stream.stages==[stage]
  end

end
