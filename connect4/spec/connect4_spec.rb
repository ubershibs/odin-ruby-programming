# spec/string_calculator_spec.rb

require "connect4"

describe Connect4 do
  let(:game) { Connect4.new }

  before(:each) do
    allow(game).to receive(:puts)
    allow(game).to receive(:print)
  end

  describe "#new" do
    it "creates a new game instance" do
      expect(game).to be_an_instance_of(Connect4)
    end

    it "creates two player objects, red and blue" do
      expect(game.p1).to have_attributes( :color => :red )
      expect(game.p2).to have_attributes( :color => :blue )
    end

    it "sets up an empty board" do
      expect(game.board).to be_an_instance_of(Board)
      expect(game.board.grid).to include([:blank, :blank, :blank, :blank, :blank, :blank])
      expect(game.board.grid).not_to include(game.p1)
    end
  end

  describe "#get_input" do 
    it "does not accept blank input" do
      allow(game).to receive(:gets).and_return("","", "2", "3")
      expect(game.get_input("Input")).to eq("2")
    end
  end

  describe "#valid_input?" do
    it "rejects when column is full" do
      6.times { game.board.place_piece(game.p1, 1) }
      expect(game.valid_input?(2)).to be false
    end

    it "accepts when column is not full" do
      expect(game.valid_input?(3)).to be true
    end

    it "rejects invalid column numbers" do
      expect(game.valid_input?(8)).to be false
    end
  end

  describe "#current_player" do 
    it "determines current player based on turn" do
      expect(game.current_player).to eq(game.p1)
    end
  end

  describe "#game_over?" do 
    it "is not over if no lines found" do
      game.set_turn(1)
      game.board.setup_empty
      expect(game.game_over?).to be false
      expect(game).to have_attributes(:winner => nil)
    end

    it "is over once board is full" do
      game.set_turn(43)
      expect(game.game_over?).to be true
      expect(game).to have_attributes(:winner => :draw)
    end

    it "is true if a horizontal line is found" do
      game.board.setup_empty
      game.board.place_piece(game.p1, 1)
      game.board.place_piece(game.p1, 2)
      game.board.place_piece(game.p1, 3)
      game.board.place_piece(game.p1, 4)
      game.horizontal_win?
      expect(game.horizontal_win?).to be true
      expect(game.game_over?).to be true
      expect(game).to have_attributes(:winner => game.p1)
    end

    it "is true if a horizontal line is found" do
      game.board.setup_empty
      game.board.place_piece(game.p1, 2)
      game.board.place_piece(game.p1, 2)
      game.board.place_piece(game.p1, 2)
      game.board.place_piece(game.p1, 2)
      game.vertical_win?
      expect(game.vertical_win?).to be true
      expect(game.game_over?).to be true
      expect(game).to have_attributes(:winner => game.p1)
    end

    it "is true if a diagonal line is found" do
      game.board.setup_empty
      3.times { game.board.place_piece(game.p1, 0) }
      2.times { game.board.place_piece(game.p1, 1) }
      game.board.place_piece(game.p1, 2)
      game.board.place_piece(game.p2, 0)
      game.board.place_piece(game.p2, 1)
      game.board.place_piece(game.p2, 2)
      game.board.place_piece(game.p2, 3)
      game.diag_win_left?
      expect(game.diag_win_left?).to be true
      expect(game.game_over?).to be true
      expect(game).to have_attributes(:winner => game.p2)
    end
  end

  describe "#play" do
  end
end