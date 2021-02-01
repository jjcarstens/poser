import Config

ca_certs = Path.expand("../ssl/dev", __DIR__)

# API HTTP connection.
config :nerves_hub_user_api,
  ca_certs: ca_certs,
  host: "0.0.0.0",
  port: 4002,
  server_name_indication: 'api.nerves-hub.org'

# Device HTTP connection.
config :nerves_hub_link,
  ca_certs: ca_certs,
  device_api_host: "0.0.0.0",
  device_api_port: 4001,
  ssl: [server_name_indication: 'device.nerves-hub.org']
