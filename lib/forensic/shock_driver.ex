defmodule Forensic.ShockDriver do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(KafkaEx.Server0P8P2,
      [
        [uris: Application.get_env(:kafka_ex, :brokers),
          consumer_group: Application.get_env(:kafka_ex, :consumer_group)],
        :no_name
      ]
    )
  end
end
