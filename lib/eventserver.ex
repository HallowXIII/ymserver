defmodule Ymserver.EventServer do
  use GenServer

  def init(gs) do
    {:ok, gs}
  end

  def handle_call(:exits, _, gs) do
    r = gs.exits
      |> Map.keys
      |> Enum.map(fn (y) -> Atom.to_string(y) end)
      |> Enum.join(" ")
    {:reply, r, gs}
  end

  def handle_call(:describe, _, gs) do
    {:reply, gs.description, gs}
  end

  def handle_call(cmd, _, gs) do
    next = GenServer.call({:global, :global_state}, Map.get(gs.exits, cmd, nil))
    if next do
      {:reply, "Ok", next}
    else
      {:reply, "No exit that way!", gs}
    end
  end

end
