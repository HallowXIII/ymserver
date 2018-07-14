defmodule Ymserver.TestGame do

  def east do
    %Ymserver.GameState{name: "East Room",
                    description: "This room is comfortably furnished.",
                        exits: %{}}
  end

  def north do
    %Ymserver.GameState{name: "North Room",
                     description: "This room is filled with glowing magma!",
                        exits: %{east: east(), west: memes()}}
  end

  def memes do
    %Ymserver.GameState{name: "Memes Room",
                        description: "This room is filled with jpeg artifacts! You lose 5 sanity.",
    exits: %{}}
  end

  def begin do
    %Ymserver.GameState{name: "Starting Room",
                     description: "A bland, nondescript room. There is a door to the north.",
                        exits: %{north: north()}}
  end

end
