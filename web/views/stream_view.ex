defmodule Forensic.StreamView do
  use Forensic.Web, :view

  alias Forensic.StageParam, as: SP
  alias Forensic.MirrorParam, as: MP
  alias Forensic.Repo
  alias Forensic.Stream, as: S

  import Ecto.Query, only: [from: 2]

  def boolean_to_color(true), do: "green"
  def boolean_to_color(_), do: "red"

  def boolean_to_text(true, text), do: text
  def boolean_to_text(_, text), do: "Not "<>text

  def check_stage(stream, step) do
    cond1 = stream.created?
    cond2 = not S.missing_parameters?(stream)
    cond3 = stream.injected?

    steps = %{
      "0" => true,
      "1" => cond1,
      "2" => cond1 and cond2,
      "3" => cond1 and cond2 and cond3,
      "4" => false
    }

    previous_step = String.to_integer(step) |> Kernel.-(1) |> Integer.to_string

    case Map.get(steps, step) do
      true ->
        case Map.get(steps, previous_step) do
          true ->
            "completed"
          _ ->
            "disabled"
        end

      _ ->
        case Map.get(steps, previous_step) do
          true ->
            "active"
          _ ->
            "disabled"
        end
    end
  end

  def required_title(true), do: "R"
  def required_title(_), do: "O"

  def required_label(true), do: "red"
  def required_label(_), do: "blue"

  def required_tooltip(true), do: "This param is required!"
  def required_tooltip(_), do: "This param is optional."
end
