import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :poser,
  ca_certs: Path.expand("../ssl/#{Mix.env()}", __DIR__),
  target: Mix.target()

config :poser, Poser.Configurator,
  certfile: "poser-cert.pem",
  keyfile: "poser-key.pem"

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

config :nerves, source_date_epoch: "1613680624"

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

if Mix.target() == :host or Mix.target() == :"" do
  import_config "host.exs"
else
  import_config "target.exs"
end

config :nerves_hub_cli,
  home_dir: Path.expand("../nerves-hub/#{env}", __DIR__)

config :nerves_hub_user_api, ca_store: Poser.Configurator

config :nerves_hub_link,
  remote_iex: true,
  ca_store: Poser.Configurator,
  fwup_public_keys: [
    # local devkey
    "ypN6eUscEjCqo4Nvm8KkABywcPzuaOReKfZqn57zYIQ="
  ]
