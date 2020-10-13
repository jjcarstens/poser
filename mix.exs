defmodule Poser.MixProject do
  use Mix.Project

  def project do
    [
      app: :poser,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:nerves_hub_link_http, "~> 0.8"},
      {:nerves_hub_link, "~> 0.9"}
    ]
  end
end
