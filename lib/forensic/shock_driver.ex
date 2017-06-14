defmodule Forensic.ShockDriver do
  use GenServer

  def start_link(opts \\ []) do
    schedule_work()
    GenServer.start_link(KafkaEx.Server0P8P2,
      [
        [uris: Application.get_env(:kafka_ex, :brokers),
          consumer_group: Application.get_env(:kafka_ex, :consumer_group)],
        :no_name
      ]
    )
  end

  def handle_info(:rebatch, state) do
    Repo.destroy_all Forensic.Report
    KafkaEx.produce("new_pipeline_instruction", 0, "flush;{}")
    {:noreply, state}
  end

  defp schedule_work() do
    one_hour = 1_000*60*60
    Process.send_after(self(), :rebatch, one_hour)
  end
end
