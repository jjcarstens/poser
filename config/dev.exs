import Config

# Shared Configuration.
config :nerves_hub_link,
  ca_certs: Path.expand("../ssl/dev", __DIR__)

# API HTTP connection.
config :nerves_hub_user_api,
  host: "0.0.0.0",
  port: 4002,
  server_name_indication: 'api.nerves-hub.org',
  ca_certs: Path.expand("../ssl/dev", __DIR__)

# Device HTTP connection.
config :nerves_hub_link,
  device_api_host: "0.0.0.0",
  device_api_port: 4001,
  server_name_indication: 'api.nerves-hub.org'
