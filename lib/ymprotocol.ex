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
      Ymserver.TestGame.begin())
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport, eserv: eserv, buf: ""})
  end

  def handle_event(state = %{socket: socket, transport: transport,
    eserv: eserv, buf: buf}) do
      IO.inspect buf
      rmess = case buf do
                "describe" -> GenServer.call(eserv, :describe)
                "exits" -> GenServer.call(eserv, :exits)
                "north" ->  GenServer.call(eserv, :north)
                "east" ->   GenServer.call(eserv, :east)
                "west" -> GenServer.call(eserv, :west)
                "south" ->  GenServer.call(eserv, :south)
                "quit" -> "Quitting"
                _ -> "Unknown command"
              end
      transport.send(socket, rmess <> "\r\n")
      {:noreply, Map.put(state, :buf, "")}
  end

  @doc """
  Handles tcp data. Allows for clients in both raw and cooked mode.
  """
  def handle_info({:tcp, socket, data}, state = %{socket: socket, buf: buf}) do
    cond do
      String.match?(data, ~r/.*\r\n/) ->
        handle_event(Map.put(state, :buf, buf <> String.trim(data)))
      data == "\b" ->
        {:noreply, Map.put(state, :buf, String.slice(buf, 0..-2))}
      true ->
        {:noreply, Map.put(state, :buf, buf <> data)}
    end
  end

  def handle_info({:tcp_closed, socket}, state = %{socket: socket, transport: transport}) do
    IO.puts "Closing"
    transport.close(socket)
    {:stop, :normal, state}
  end
end
