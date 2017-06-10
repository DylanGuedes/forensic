defmodule Forensic.AlertController do
  use Forensic.Web, :controller

  def index(conn, _params) do
    KafkaEx.produce("new_pipeline_instruction", 0, "flush;{}")
    render(conn, "index.html")
  end
end
