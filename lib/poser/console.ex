defmodule Poser.Console do
  use GenServer
  require Logger

  defmodule State do
    defstruct socket: nil,
              topic: "console",
              channel: nil,
              params: [],
              iex_pid: nil,
              request: nil,
              retry_count: 0
  end

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  def start(opts \\ []), do: GenServer.start(__MODULE__, opts, name: __MODULE__)

  def init(opts) do
    state = State.__struct__(opts)
    send(self(), :join)

    {:ok, state}
  end

  def reply(data) do
    GenServer.call(__MODULE__, {:io_reply, data})
  end

  def restart do
    GenServer.call(__MODULE__, :restart)
  end

  def handle_call(:restart, _from, state) do
    Process.exit(state.iex_pid, :kill)
    create_or_reuse_iex_server(state)
  end

  def handle_call({:io_reply, data}, _from, state) do
    {from, reply_as, _} = state.request
    {:reply, io_reply(from, reply_as, data), state}
  end

  def handle_info(:join, state) do
    create_or_reuse_iex_server(state)
  end

  # Handle IO Request from IEx Server
  def handle_info({:io_request, from, reply_as, request}, state) do
    Logger.info("IO_REQUEST - #{inspect(request)}")
    state = io_request(from, reply_as, request, state)
    {:noreply, state}
  end

  def handle_info(req, state) do
    Logger.warn("Unhandled Console handle_info - #{inspect(req)}")
    {:noreply, state}
  end

  defp create_or_reuse_iex_server(%{iex_pid: iex_pid} = state) when is_pid(iex_pid) do
    with true <- Process.alive?(state.iex_pid),
         {:group_leader, gl_pid} <- Process.info(state.iex_pid, :group_leader),
         true <- gl_pid == self() do
      # We already have an IEx Server running, so keep using it
      {:noreply, state}
    else
      _err ->
        Logger.warn("IEx Group Leader changed or died. Restarting")
        Process.exit(state.iex_pid, :kill)
        # restart IEx process
        create_or_reuse_iex_server(%{state | iex_pid: nil})
    end
  end

  defp create_or_reuse_iex_server(state) do
    iex_pid = spawn_link(fn -> IEx.Server.run([]) end)
    Process.group_leader(iex_pid, self())

    {:noreply, %{state | iex_pid: iex_pid}}
  end

  # Send IO Reply to IEx server
  defp io_reply(from, reply_as, reply) do
    Logger.debug("IO REPLY - #{inspect(reply)}")
    send(from, {:io_reply, reply_as, reply})
  end

  ##
  # Match the :io_request commands from IEx Server
  #

  # :setopts not supported
  defp io_request(from, reply_as, {:setopts, _opts}, state) do
    reply = {:error, :enotsup}
    io_reply(from, reply_as, reply)
    state
  end

  # :getopts not supported
  defp io_request(from, reply_as, :getopts, state) do
    reply = {:ok, [binary: true, encoding: :unicode]}
    io_reply(from, reply_as, reply)
    state
  end

  # :get_geometry not supported
  defp io_request(from, reply_as, {:get_geometry, :columns}, state) do
    reply = {:error, :enotsup}
    io_reply(from, reply_as, reply)
    state
  end

  defp io_request(from, reply_as, {:get_geometry, :rows}, state) do
    reply = {:error, :enotsup}
    io_reply(from, reply_as, reply)
    state
  end

  defp io_request(from, reply_as, {:get_line, _encoding, _data} = req, state) do
    %{state | request: {from, reply_as, req}}
  end

  defp io_request(from, reply_as, {:put_chars, encoding, module, function, args}, state) do
    # Judicious try block so we can return back the error tuple
    # as defined in http://erlang.org/doc/apps/stdlib/io_protocol.html#output-requests
    try do
      data = apply(module, function, args)
      io_request(from, reply_as, {:put_chars, encoding, data}, state)
    catch
      thrown_value ->
        Logger.warn(thrown_value)
        io_reply(from, reply_as, {:error, thrown_value})
    end
  end

  defp io_request(from, reply_as, {:put_chars, _encoding, _data}, state) do
    io_reply(from, reply_as, :ok)

    %{state | retry_count: 0}
  end

  defp io_request(_, _, req, state) do
    Logger.warn("Unknown IO Request !! - #{inspect(req)}")
    state
  end
end
