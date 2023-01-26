import Config

config :poser, Poser.Configurator,
  certfile: {:system, "POSER_CERT", "poser-cert.pem"},
  keyfile: {:system, "POSER_KEY", "poser-key.pem"}

# API HTTP connection.
config :nerves_hub_user_api,
  host: "0.0.0.0",
  port: 4002,
  server_name_indication: 'api.nerves-hub.org'

# Device HTTP connection.
config :nerves_hub_link,
  device_api_host: "0.0.0.0",
  device_api_port: 4001,
  ssl: [server_name_indication: 'device.nerves-hub.org']
