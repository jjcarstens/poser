defmodule Poser.MixProject do
  use Mix.Project

  # @all_targets [:rpi3, :rpi0, :rpi3a]

  def project do
    [
      app: :poser,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      included_applications: [:distillery],
      mod: {Poser.Application, []}
    ]
  end

  defp deps do
    [
      {:nerves_hub_device, path: "../nerves_hub_device"},
      {:shoehorn, "~> 0.5"},
      {:toolshed, "~> 0.2"}
    ]
  end
end
