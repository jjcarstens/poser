import Config

# Mock NervesRuntime
config :nerves_runtime, :kernel, autoload_modules: false
config :nerves_runtime, target: "host"

config :nerves_runtime, Nerves.Runtime.KV.Mock, %{
  "nerves_fw_active" => "a",
  "a.nerves_fw_uuid" => "8a8b902c-d1a9-58aa-6111-04ab57c2f2a8",
  "a.nerves_fw_product" => "poser",
  "a.nerves_fw_architecture" => "x86_64",
  "a.nerves_fw_version" => "0.1.0",
  "a.nerves_fw_platform" => "x86_84",
  "a.nerves_fw_misc" => "extra comments",
  "a.nerves_fw_description" => "test firmware",
  "nerves_fw_devpath" => "/tmp/fwup_bogus_path",
  "nerves_serial_number" => "poser"
}

config :nerves_runtime, :modules, [
  {Nerves.Runtime.KV, Nerves.Runtime.KV.Mock}
]

# use Environment var env instead of Mix.env
env =
  cond do
    System.get_env("PROD") ->
      :prod

    System.get_env("STAGING") ->
      :staging

    true ->
      :dev
  end

import_config "#{env}.exs"

config :nerves_hub_cli,
  home_dir: Path.expand("../nerves-hub/#{env}", __DIR__)

config :nerves_hub_link,
  configurator: Poser.Configurator,
  remote_iex: true
