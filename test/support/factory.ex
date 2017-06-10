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
      description: "nice stage",
      step: "processing",
      shock_identifier: "niceFunction"
    }
  end

  def changelog_factory do
    %Forensic.Changelog{
      description: "nice log"
    }
  end

  def mirror_param_factory do
    %Forensic.MirrorParam{
      param_type: "string",
      title: "niceparam",
      required?: true
    }
  end
end
