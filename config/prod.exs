import Config

# ca_certs = Path.expand("../ssl/prod", __DIR__)

# API HTTP connection.
config :nerves_hub_user_api,
  host: "api.nerves-hub.org",
  port: 443

# Device HTTP connection.
config :nerves_hub_link,
  device_api_host: "device.nerves-hub.org",
  device_api_port: 443,
  ssl: [server_name_indication: 'device.nerves-hub.org'],
  reconnect_interval: 1_000
