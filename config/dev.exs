use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :digitalocean_connector, DigitalOceanConnector.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :digitalocean_connector, DigitalOceanConnector.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure 3rd parties
config :digitalocean_connector,
  dnsimple_client_id: "bbf472f1dcc6d611",
  dnsimple_client_secret: "JHIKTQjbzCtoBlf0TKpvE1B7jj0DzdrZ",
  digitalocean_client_id: "a5112b0d1ca19f0b01027e87969c778dc9213fe9da2f834a0abcfc28d568f8b7",
  digitalocean_callback_url: "http://localhost:4000/digitalocean/callback",
  digitalocean_client_secret: "344363138b6bc11173c19e649c43a0330526a5b25debaa426050527a7ad5793c"
