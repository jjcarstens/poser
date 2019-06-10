defmodule Poser.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Connect to my local IP running local NervesHubWeb
    :inet_db.add_host({10,0,1,36}, ['nerves-hub.org'])

    children = []

    opts = [strategy: :one_for_one, name: Poser.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
