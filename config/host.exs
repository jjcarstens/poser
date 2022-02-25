import Config

# Mock NervesRuntime
config :nerves_runtime, :kernel, autoload_modules: false
config :nerves_runtime, target: "host"

config :nerves_runtime, Nerves.Runtime.KV.Mock, %{
  "nerves_fw_active" => "a",
  "a.nerves_fw_uuid" => "5cb84916-4c7c-55e9-2d20-e32ec6ba0b13",
  "a.nerves_fw_product" => "smartrent_hub_fw",
  "a.nerves_fw_architecture" => "arm",
  "a.nerves_fw_version" => "0.1.0",
  "a.nerves_fw_platform" => "Smartrent Hub",
  "a.nerves_fw_misc" => "extra comments",
  "a.nerves_fw_description" => "test firmware",
  "nerves_fw_devpath" => "/tmp/fwup_bogus_path",
  "nerves_serial_number" => "poser"
}

config :nerves_runtime, :modules, [
  {Nerves.Runtime.KV, Nerves.Runtime.KV.Mock}
]

config :nerves_hub_link, configurator: Poser.Configurator
