# spec/chess_spec.rb 
require 'chess'

describe Chess do

  let(:game) {Chess.new}

  before(:each) do
    allow(game).to receive(:puts)
    allow(game).to receive(:print)
  end

  it "creates a board" do
    expect(game.board).to be_an_instance_of Board
  end

  describe "#input" do 
    it "prompts player to input a move" do
      allow(game).to receive(:gets).and_return("a1 h8")
      expect(game.input).to eq("A1 H8")
    end
  end

  describe "#input_valid?" do 
    it "does not allow invalid input" do
      expect(game.input_valid?("ah 2H")).to be false
    end
  end

  describe "#parse_move" do
    it "returns an array with start and end squares" do
     expect(game.parse_move("A8 H8")).to eq(["A8", "H8"])
    end
  end

  describe "#curr_player" do 
    it "returns white when turn is odd" do
      expect(game.curr_player).to eq("white")
    end
  end

end

describe Board do

  let(:board) {Board.new}
  
  before(:each) do
    allow(board).to receive(:puts)
    allow(board).to receive(:print)
  end
  
  it "creates a new board" do
    expect(board.grid).to be_an_instance_of Hash
  end

  it "creates keys for A1-H8" do
    expect(board.grid).to include("D4"=>nil)
  end

  describe "#get_coordinates" do
    it "converts user input to coordinates" do
      expect(board.get_coordinates("A1")).to eq([1,1])
    end
  end

  describe "#get_key" do
    it "converts coordinates to keys/user input" do
      expect(board.get_key(4, 4)).to eq("D4")
    end
  end

  describe "#calc_moves" do
    it "returns an array of valid moves" do
      piece = Piece.new("pawn","white")
      board.calc_moves(piece, 1, 2)
      expect(piece).to have_attributes(:possible_moves=>["A3", "A4"])
    end

    it "works for pieces that can jump as well" do
      piece = Piece.new("knight","white") 
      board.calc_moves(piece, 2, 1)
      expect(piece).to have_attributes(:possible_moves=>["C3", "A3"])
    end
  end

  describe "#check_move" do
    it "returns false if a move is invalid" do
      expect(board.check_move(["A1","B1"],"white")).to be false
      expect(board.check_move(["C8", "C5"],"black")).to be false
    end

    it "returns true if a move is valid" do
      expect(board.check_move(["E7", "E6"],"black")).to be true
    end
  end

  describe "#complete_move" do
    it "moves the piece to the destination" do
      piece = Piece.new("rook","white")
      board.grid["A4"] = piece
      expect(board.complete_move("A4", "A8", piece)).to be true
      expect(board.grid["A8"]).to eq(piece)
    end
  end
 
  describe "#in_check?" do
    it "returns true if king is in jeopardy" do
      board.grid["E7"] = Piece.new("queen","white")
      expect(board.in_check?("black")).to be true
      expect(board.in_check?("white")).to be false
    end
  end

end

describe Piece do

  let(:rook) {Piece.new("rook","white")}

  it "creates the expected type/color of piece" do
    expect(rook).to have_attributes(:type=>"rook", :color=>"white", :possible_moves=>[])
  end

end
