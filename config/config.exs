use Mix.Config

import_config "../../nerves_hub_device/config/dev.exs"

config :nerves_runtime, :kernel, autoload_modules: false
config :nerves_runtime, target: "host"

config :shoehorn,
  app: :poser

# Add your app specific settings to local.exs
import_config "local.exs"
