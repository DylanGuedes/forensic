defmodule Forensic.StreamView do
  use Forensic.Web, :view

  alias Forensic.StageParam, as: SP
  alias Forensic.MirrorParam, as: MP
  alias Forensic.Repo

  import Ecto.Query, only: [from: 2]

  def can_configure?([]), do: true
  def can_configure?(array), do: false
  def can_configure?(param, stream, stage) do
    q = from p in SP, where: p.stream_id == ^stream.id and p.mirror_id == ^param.id
    result = Repo.all q
    can_configure?(result)
  end

  def related_params(stream, stage) do
    q = from p in SP, where: p.stream_id==^stream.id and p.stage_id==^stage.id, preload: :mirror
    Repo.all q
  end

  def has_mirror_params?(stage_id) do
    q = from p in MP, where: p.stage_id==^stage_id
    result = Repo.all q
    case result do
      [] ->
        false
      [h|t] ->
        true
      _ ->
        false
    end
  end

  def ribbon_color(injected?) do
    case injected? do
      true ->
        "green"
      false ->
        "red"
      _ ->
        "red"
    end
  end

  def injected_text?(injected?) do
    case injected? do
      true ->
        "Injected"
      _ ->
        "Not injected"
    end
  end
end
