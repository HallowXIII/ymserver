defmodule Ymserver.GlobalState do
  use GenServer

  def init(_) do
    {:ok, build_roomtable()}
  end

  def build_roomtable() do
    rt = %{}
    Map.put(rt, TestGame.east)
  end
end
