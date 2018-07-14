defmodule Ymserver do
  use Application
  @moduledoc """
  Documentation for Ymserver.
  """

  @doc """
  """
  def start(_type, _args) do
    :ranch.start_listener(:ym_listener, 100, :ranch_tcp,
      [port: 5555], Ymserver.YmProtocol, [])
  end
end
