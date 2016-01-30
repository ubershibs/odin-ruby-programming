# lib/chess.rb 

class Chess

  attr_reader :board, :turn

  def initialize
    @board = Board.new
    @turn = 1
  end

  def input
    input = " "
    player = curr_player
    print "#{player.capitalize}: Please input your move: "
    loop do
      input = gets.chomp.upcase
      break if input_valid?(input)
    end
    return input
  end

  def input_valid?(input)
    if input =~ /[A-H][1-8]\s[A-H][1-8]/
      return true
    else
      puts "Valid moves look like this: A8 H1. Try again."
      return false
    end
  end

  def parse_move(input)
    ary = input.split(" ")
    ary
  end

  def curr_player
    current = @turn.odd? ? "white" : "black"
    current
  end

  def turn
    moved = false
    until moved == true
      move = input
      move_ary = parse_move(move)
      moved = @board.check_move(move_ary, curr_player)
    end
    @turn += 1
  end

  def play
    loop do
      turn
    end
  end
end

class Board

  CONVERSIONS = ["NA", "A", "B", "C", "D", "E", "F", "G", "H"]

  attr_reader :grid

  def initialize
    @grid = Hash.new
    setup
  end

  def setup
    ("A".."H").each do |col|
      ("1".."8").each do |row|
        key = "#{col}#{row}"
        piece = 
        if row == "2"
          Piece.new("pawn","white")
        elsif key == "A1"
          Piece.new("rook","white")
        elsif key == "B1"
          Piece.new("knight","white")
        elsif key == "C1"
          Piece.new("bishop","white")
        elsif key == "D1"
          Piece.new("queen","white")
        elsif key == "F1"
          Piece.new("bishop","white")
        elsif key == "G1"
          Piece.new("knight","white")
        elsif key == "H1"
          Piece.new("rook","white")
        elsif key == "A8"
          Piece.new("rook","black")
        elsif key == "B8"
          Piece.new("knight","black")
        elsif key == "C8"
          Piece.new("bishop","black")
        elsif key == "D8"
          Piece.new("queen","black")
        elsif key == "F8"
          Piece.new("bishop","black")
        elsif key == "G8"
          Piece.new("knight","black")
        elsif key == "H8"
          Piece.new("rook", "black")
        elsif row == "7"
          Piece.new("pawn","black")
        else
          nil
        end
        @grid[key] = piece
      end
    end
  end

  def check_move(move, player)
    start, dest = move
    piece = @grid[start] 
    if piece.color != player
      puts "You must select one of your own pieces, #{player.downcase}"
      return false
    end
    x,y = get_coordinates(start)
    calc_moves(piece, x, y)
    unless piece.possible_moves.include?(dest)
      puts "Your move is not legal. Please enter another move."
      return false
    end
    complete_move(start, dest, piece)
    return true
  end

  def complete_move(start, dest, piece)
    dest_occupant = @grid[dest]
    unless dest_occupant.nil?
      if dest_occupant.color != piece.color
        puts "#{dest_occupant.color.capitalize} #{dest_occupant.type} captured! "
        dest_occupant.moved = "CAPTURED"
      end
    end
    @grid[dest] = piece
    puts "#{piece.color.capitalize} #{piece.type} moved to #{dest}."
    piece.moved = true
    @grid[start] = nil
    return true
  end

  def get_coordinates(square)
    x,y = square.split("")
    x = CONVERSIONS.index(x)
    y = y.to_i
    ary = [x,y]
    ary
  end

  def get_key(x,y)
    x = CONVERSIONS[x]
    key = "#{x}#{y}"
    key
  end

  def calc_moves(piece, x, y)
    if piece.type == "rook"
      calc_moves_rook(piece, x, y)
    elsif piece.type == "bishop"
      calc_moves_bishop(piece, x, y)
    elsif piece.type == "queen"
      calc_moves_queen(piece, x, y)
    elsif piece.type == "pawn"
      calc_moves_pawn(piece, x, y)
    end
  end


  def line_moves(piece, start_x, start_y, inc_x, inc_y, direction)
    moves = Array.new
    i = inc_x * direction
    j = inc_y * direction
    loop do
      new_x = start_x + i
      new_y = start_y + j
      break unless new_x.between?(1, 8) && new_y.between?(1, 8)
      key = get_key(new_x, new_y)
      square = @grid[key]
      unless square.nil?
        moves << key unless square.color == piece.color
        break
      end
      moves << key
      i += inc_x * direction
      j += inc_y * direction
    end
    moves
  end

  def get_line_moves(piece, start_x, start_y, inc_x, inc_y)
    line_moves(piece, start_x, start_y, inc_x, inc_y, 1) +  line_moves(piece, start_x, start_y, inc_x, inc_y, -1)
  end

  def calc_moves_rook(piece, x, y)
    piece.possible_moves = get_line_moves(piece, x, y, 1, 0) + get_line_moves(piece, x, y, 0, 1)
  end

  def calc_moves_bishop(piece, x, y)
    piece.possible_moves = get_line_moves(piece, x, y, 1, 1) + get_line_moves(piece, x, y, 1, -1)
  end

  def calc_moves_queen(piece, x, y)
    piece.possible_moves = get_line_moves(piece, x, y, 1, 1) + get_line_moves(piece, x, y, 1, -1) + get_line_moves(piece, x, y, 1, 0) + get_line_moves(piece, x, y, 0, 1)
  end

  def calc_moves_pawn(piece, x, y)
    if piece.color == "white"
      j = 1
    elsif piece.color == "black"
      j = -1
    end
    pawn_base_case(piece, x, y, j)
    pawn_first_move(piece, x, y, j)
    pawn_capture(piece, x, y, -1, j)
    pawn_capture(piece, x, y, 1, j)
  end

  def pawn_base_case(piece, x, y, j)
    new_y = y + j
    return false unless new_y.between?(1, 8)
    key = get_key(x, new_y)
    square = @grid[key]
    if square.nil?
      piece.possible_moves << key
    end
  end

  def pawn_first_move(piece, x, y, j)
    if piece.moved == false
      new_y = y + j
      return false unless new_y.between?(1,8)
      bonus_y = new_y + j
      key1 = get_key(x, new_y)
      square = @grid[key1]
      if square.nil?
        return false unless bonus_y.between?(1,8)
        key2 = get_key(x, bonus_y)
        square2 = @grid[key2]
        if square2.nil?
          piece.possible_moves << key2
        end
      end
    end
  end

  def pawn_capture(piece, x, y, i, j)
    new_x = x + i
    new_y = y + j
    key = get_key(new_x, new_y)
    square = @grid[key]
    unless square.nil?
      if square.color != piece.color
        piece.possible_moves << key
      end
    end
  end


end

class Piece

  attr_reader :type, :color
  attr_accessor :possible_moves, :moved

  def initialize(type, color)
    @type = type
    @color = color
    @moved = false
    @possible_moves = Array.new
  end

end

game = Chess.new
game.play