defmodule Forensic.StageView do
  use Forensic.Web, :view

  def normalize_param_type(param) do
    case param do
      "1" ->
        "string"
      "2" ->
        "int"
      "3" ->
        "double"
      _ ->
        "unknown"
    end
  end
end
