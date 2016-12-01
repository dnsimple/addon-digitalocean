use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :digitalocean_connector, DigitalOceanConnector.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure 3rd parties
config :digitalocean_connector,
  dnsimple_client_id: "dnsimple-client-id",
  dnsimple_client_secret: "dnsimple-client-secret",
  digitalocean_client_id: "digitalocean-client-id",
  digitalocean_callback_url: "http://host.tld:4000/digitalocean/callback",
  digitalocean_client_secret: "digitalocean-client-secret"

# Mock Services
config :digitalocean_connector,
  connection_service: DigitalOceanConnector.ConnectionServiceMock,
  dnsimple_oauth_service: DigitalOceanConnector.Dnsimple.OauthMock,
  dnsimple_identity_service: DigitalOceanConnector.Dnsimple.IdentityMock,
  dnsimple_domains_service: DigitalOceanConnector.Dnsimple.DomainsMock,
  digitalocean_oauth_service: DigitalOceanConnector.DigitalOcean.OauthMock
