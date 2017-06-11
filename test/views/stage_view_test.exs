defmodule Forensic.StageViewTest do
  use Forensic.ConnCase, async: true

  alias Forensic.StageView, as: StgV

  test "#normalize_param_type should be correct" do
    assert StgV.normalize_param_type("1")=="string"
    assert StgV.normalize_param_type("2")=="int"
    assert StgV.normalize_param_type("3")=="double"
    assert StgV.normalize_param_type(1)=="unknown"
  end
end
