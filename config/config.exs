# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :digitalocean_connector,
  namespace: DigitalOceanConnector,
  ecto_repos: [DigitalOceanConnector.Repo]

# Configures the endpoint
config :digitalocean_connector, DigitalOceanConnector.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZysiQ4QjzHpdsygLjrzSeNm52kh0T3WedwloiIZ5NgMVlFGobKaFbEL8C/g9CMxd",
  render_errors: [view: DigitalOceanConnector.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DigitalOceanConnector.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
