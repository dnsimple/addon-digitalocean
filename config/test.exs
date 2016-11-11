use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :digitalocean_connector, DigitalOceanConnector.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :digitalocean_connector, DigitalOceanConnector.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  # password: "postgres",
  database: "digitalocean_connector_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :digitalocean_connector,
  dnsimple_client_id: "dnsimple-client-id",
  dnsimple_client_secret: "dnsimple-client-secret",
  digitalocean_client_id: "digitalocean-client-id",
  digitalocean_callback_url: "http://host.tld:3000/digitalocean/callback",
  digitalocean_client_secret: "digitalocean-client-secret",
  dnsimple_oauth_service: DigitalOceanConnector.Dnsimple.OauthMock,
  dnsimple_identity_service: DigitalOceanConnector.Dnsimple.IdentityMock
