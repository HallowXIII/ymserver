defmodule Ymserver.YmProtocol do
  use GenServer

  @behaviour :ranch_protocol

  def start_link(ref, socket, transport, _opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(args) do
    {:ok, args}
  end

  def init(ref, socket, transport) do
    IO.puts "Starting protocol"

    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    {:ok, eserv} = GenServer.start_link(Ymserver.EventServer,
      Ymserver.TestGame.begin(), name: YmEvServ)
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport, eserv: eserv})
  end

  def handle_info({:tcp, socket, data}, state = %{socket: socket, transport: transport, eserv: eserv}) do
    IO.inspect data
    rmess = case String.trim(data) do
              "describe" -> GenServer.call(eserv, :describe)
              "exits" -> GenServer.call(eserv, :exits)
              "north" ->  GenServer.call(eserv, :north)
              "east" ->   GenServer.call(eserv, :east)
              "west" -> GenServer.call(eserv, :west)
              "south" ->  GenServer.call(eserv, :south)
              "quit" -> "Quitting"
              _ -> "Unknown command"
            end
    transport.send(socket, rmess)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state = %{socket: socket, transport: transport}) do
    IO.puts "Closing"
    transport.close(socket)
    {:stop, :normal, state}
  end
end
