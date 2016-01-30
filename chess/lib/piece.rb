# lib/piece.rb

class Piece

  attr_reader :type, :color, :symbol
  attr_accessor :possible_moves, :moved

  def initialize(type, color)
    @type = type
    @color = color
    @moved = false
    @possible_moves = Array.new
    @symbol = set_symbol
  end

  def set_symbol
    symbols = {"rook"=>"r", "knight"=>"n", "bishop"=>"b", "queen"=>"q", "king"=>"k", "pawn"=>"p"}
    if @color == "white"
      @symbol = symbols[@type].downcase
    elsif @color == "black"
      @symbol = symbols[@type].upcase
    end
  end

end
