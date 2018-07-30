defmodule Ymserver.GlobalState do
  use GenServer

  def init(_) do
    {:ok, build_roomtable()}
  end

  def handle_call(cmd, _, rtbl) do
    {:reply, Map.get(rtbl, cmd, nil), rtbl}
  end

  def build_roomtable() do
    %{}
    |> Map.put("east", Ymserver.TestGame.east)
    |> Map.put("north", Ymserver.TestGame.north)
    |> Map.put("memes", Ymserver.TestGame.memes)
    |> Map.put("begin", Ymserver.TestGame.begin)
  end
end
