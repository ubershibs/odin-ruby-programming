require 'spec_helper'

describe Game do
  before(:each) do
    @game = Game.new
  end

  it "creates a new board when initialized" do
    expect(@game.board.board).to be_an_instance_of(Array)
  end

  it "creates an empty board" do
    expect(@game.board.board).to match_array [" ", " ", " ", " ", " ", " ", " ", " ", " "]
  end

  it "declares a winner when a complete line is played" do
    board = @game.board
    allow(board).to receive(:board).and_return(["X", "X", "X", " ", " ", " ", " ", " ", " "])
    @game.check_for_winner(@game.player1)

    expect(@game.winner.marker).to eq("X")
  end

  it "does not declare a winner with full board no lines" do
    board = @game.board
    allow(board).to receive(:board).and_return(["X", "O", "X", "X", "O", "O", "O", "X", "X"])
    @game.check_for_winner(@game.player1)

    expect(@game.winner).to eq(nil)
  end
  
end