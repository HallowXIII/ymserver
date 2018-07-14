defmodule YmserverTest do
  use ExUnit.Case
  doctest Ymserver

  test "greets the world" do
    assert Ymserver.hello() == :world
  end
end
