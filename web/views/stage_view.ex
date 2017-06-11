defmodule Forensic.StageView do
  use Forensic.Web, :view

  def normalize_param_type("1"), do: "string"
  def normalize_param_type("2"), do: "int"
  def normalize_param_type("3"), do: "double"
  def normalize_param_type(_), do: "unknown"
end
