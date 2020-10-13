defmodule Poser.Configurator do
  @moduledoc """
  Implements `NervesHubLink.Configurator` behaviour

  This is called when NervesHubLink is starting and the result is used for
  configuring the NervesHubLink connection. It essentially lets us provision
  settings onto the device on first initialization and then read that data from
  disk during runtime allowing us to avoid creating hard links in compile time
  configuration settings.

  For Poser, this just helps changing context of Dev, Staging, and Prod with an
  environment variable without requiring recompilation
  """
  @behaviour NervesHubLink.Configurator

  alias NervesHubLink.Certificate

  @impl true
  def build(config) do
    certfile = Path.join("nerves-hub", "poser-cert.pem")
    keyfile = Path.join("nerves-hub", "poser-key.pem")

    signer =
      Path.join("nerves-hub", "poser-signer.cert")
      |> File.read!()

    update_config(config, certfile, keyfile, signer)
  end

  defp build_cacerts(signer) do
    signer_der = Certificate.pem_to_der(signer)

    [signer_der | cacerts()]
  end

  defp update_config(config, certfile, keyfile, signer) do
    ssl =
      config.ssl
      |> Keyword.put(:certfile, certfile)
      |> Keyword.put(:keyfile, keyfile)
      |> Keyword.put(:cacerts, build_cacerts(signer))

    socket = Keyword.put(config.socket, :reconnect_interval, 15000)

    %{config | socket: socket, ssl: ssl}
  end

  defp cacerts() do
    Application.get_env(:nerves_hub_link, :ca_certs)
    |> Path.join("*")
    |> Path.wildcard()
    |> Enum.map(&to_der/1)
  end

  defp to_der(file) do
    File.read!(file)
    |> Certificate.pem_to_der()
  end
end
