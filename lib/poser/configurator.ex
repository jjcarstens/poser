defmodule Poser.Configurator do
  @moduledoc """
  Implements `NervesHubLink.Configurator` behaviour

  This is called when NervesHubLink is starting and the result is used for
  configuring the NervesHubLink connection. It essentially lets us provision
  settings onto the device on first initialization and then read that data from
  disk during runtime allowing us to avoid creating hard links in compile time
  configuration settings.

  For Poser, this just helps changing context of Dev, Staging, and Prod with an
  environment variable without requiring recompilation.

  This is only used on host and ignored on device in firmware
  """
  @behaviour NervesHubLink.Configurator

  alias NervesHubLink.Certificate

  @impl true
  def build(config) do
    cert_config = Application.get_env(:poser, __MODULE__)

    certfile = Path.join("nerves-hub", config(cert_config[:certfile]))
    keyfile = Path.join("nerves-hub", config(cert_config[:keyfile]))

    signer =
      Path.join("nerves-hub", "poser-signer.cert")
      |> File.read!()

    update_config(config, certfile, keyfile, signer)
  end

  def ca_certs() do
    # If you need to adjust CACerts, change it here
    Path.join(Application.get_env(:poser, :ca_certs), "*")
    |> Path.wildcard()
    |> Enum.flat_map(&X509.from_pem(File.read!(&1)))
    |> Enum.map(&X509.Certificate.to_der/1)
  end

  defp build_cacerts(signer) do
    signer_der = Certificate.pem_to_der(signer)

    [signer_der | Certificate.ca_certs()]
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

  defp config({:system, env, default}), do: System.get_env(env, default)

  defp config(value), do: value
end
