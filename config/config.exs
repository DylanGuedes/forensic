# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :forensic,
  ecto_repos: [Forensic.Repo]

# Configures the endpoint
config :forensic, Forensic.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uy2s3auPNaXWQe5/tEn9Z92QtYNCF4Fu4PXTMpvEmQ9NFvj7GoklSJk3Pm003jps",
  render_errors: [view: Forensic.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Forensic.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :kafka_ex, brokers: [{"localhost", 9092}], use_ssl: false, consumer_group: "shock"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
