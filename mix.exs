defmodule Poser.MixProject do
  use Mix.Project

  @app :poser
  @version "0.1.0"
  @all_targets [:rpi0, :x86_64]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      included_applications: [],
      mod: {Poser.Application, []}
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.7.0", runtime: false},
      {:shoehorn, "~> 0.7.0"},
      {:ring_logger, "~> 0.8.1"},
      {:toolshed, "~> 0.2.13"},
      {:nerves_hub_link_http, "~> 0.8"},
      {:nerves_hub_link, "~> 0.9"},
      # {:nerves_hub_link, path: "../nerves_hub_link"},
      {:nerves_runtime, "~> 0.11.3", override: true},

      # Dependencies for all targets except :host
      {:nerves_pack, "~> 0.4", targets: @all_targets},
      {:nerves_system_rpi0, "~> 1.13", runtime: false, targets: :rpi0},
      {:nerves_system_x86_64, "~> 1.13", runtime: false, targets: :x86_64}
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
