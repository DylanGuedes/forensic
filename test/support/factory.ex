defmodule Forensic.Factory do
  use ExMachina.Ecto, repo: Forensic.Repo

  def stream_factory do
    %Forensic.Stream{
      name: "interscity stream"
    }
  end

  def stage_factory do
    %Forensic.Stage{
      title: "ingestion stage",
      description: "nice stage"
    }
  end
end
