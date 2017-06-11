defmodule Forensic.StreamViewTest do
  use Forensic.ConnCase, async: true

  alias Forensic.StreamView, as: SV

  test "#ribbon_color should work" do
    assert SV.boolean_to_color(true)=="green"
    assert SV.boolean_to_color(false)=="red"
    assert SV.boolean_to_color(nil)=="red"
  end

  test "#boolean_to_text should be correct" do
    assert SV.boolean_to_text(true, "Injected")=="Injected"
    assert SV.boolean_to_text(false, "Injected")=="Not Injected"
    assert SV.boolean_to_text(nil, "Injected")=="Not Injected"
  end

  test "#required_tooltip should be correct" do
    assert SV.required_tooltip(true)=="This param is required!"
    assert SV.required_tooltip(false)=="This param is optional."
  end
end
