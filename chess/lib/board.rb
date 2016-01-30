# lib/board.rbclass Board

require_relative   "move_helper"

class Board

  include MoveHelper

  attr_reader :grid, :last_move

  def initialize
    @grid = Hash.new
    @white_king_location = ""
    @black_king_location = ""
    @last_move = Array.new
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
        elsif key == "E1"
          Piece.new("king","white")
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
        elsif key == "E8"
          Piece.new("king","black")
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
    @white_king_location = "E1"
    @black_king_location = "E8"
  end

  def check_move(move, player)
    start, dest = move
    if @grid[start].nil?
      puts "You cannot start from an empty square"
      return false
    end

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
    if piece.type == "king" && piece.moved == false && ("D".."F").include?(dest[0]) == false
      if dest[0]=="C"
        complete_castle_left(player)
        @last_move = [start,dest,piece]
        return true
      elsif dest[0]=="G"
        complete_castle_right(player)
        @last_move = [start,dest,piece]
        return true
      end
    end
    if piece.type == "pawn" && start[0] != dest[0] && @grid[dest].nil?
      complete_en_passant(start, dest, piece)
      return true
    end
    if complete_move(start, dest, piece)
      return true
    else
      return false
    end
    @last_move = [start,dest,piece]
  end

  def king_locator(player)
    king_loc = player == "white" ? @white_king_location : @black_king_location
    king_loc
  end

  def in_check?(player, king_loc)
    threat = Array.new
    pieces = @grid.select {|k,v| v.nil? == false}
    pieces.each do |k,v|
      if v.color !=  player
        x,y = get_coordinates(k)
        calc_moves(v, x, y)
        if v.possible_moves.include?(king_loc)
          threat << v
        end
      end
    end
    if threat.empty?
      return false
    else
      return true
    end
  end

  def no_valid_move(player)
    pieces = @grid.select {|k,v| v.nil? == false}
    can_move = Array.new
    pieces.each do |k,v|
      if v.color == player
        x,y = get_coordinates(k)
        calc_moves(v, x, y)
        if v.possible_moves.empty? == false
          can_move << v
        end
      end
    end
    if can_move.empty?
      return true
    else
      return false
    end
  end

  def checkmate?(player)
    if no_valid_move(player) && in_check?(player)
      true
    else
      false
    end
  end

  def stalemate?(player)
    if no_valid_move(player)==true && in_check?(player)==false
      true
    else
      false
    end
  end

  def complete_move(start, dest, piece)
    dest_occupant = @grid[dest]
    @grid[dest] = piece
    @grid[start] = nil
    king_loc = piece.type == "king" ? dest : king_locator(piece.color)
    if in_check?(piece.color, king_loc) == true
      puts "You can't end a turn in check. Please select a new move."
      @grid[start] = piece
      @grid[dest] = dest_occupant
      return false
    end
    unless dest_occupant.nil?
      if dest_occupant.color != piece.color
        puts "#{dest_occupant.color.capitalize} #{dest_occupant.type} captured! "
        dest_occupant.moved = "CAPTURED"
      end
    end
    puts "#{piece.color.capitalize} #{piece.type} moved to #{dest}."
    piece.moved = true
    if piece.type == "king"
      @white_king_location = dest if piece.color == "white"
      @black_king_location = dest if piece.color == "black"
    end
    if piece.type == "pawn"
      if piece.color == "white" && dest[1] == "8"
        promote(dest, piece)
      elsif piece.color === "black" && dest[1] == "1"
        promote(dest, piece)
      end
    end
      @last_move = [start,dest,piece]
    return true
  end
  
  def complete_en_passant(start, dest, piece)
    if piece.color == "white"
      capture = "#{dest[0]}#{dest[1].to_i - 1}"
    elsif piece.color == "black"
      capture = "#{dest[0]}#{dest[1].to_i + 1}"
    end
    puts "#{piece.color.capitalize} captures #{grid[capture].color} pawn at #{capture} en passant while moving to #{dest}."
    @grid[capture] = nil
    @grid[dest] = piece
    @grid[start] = nil
    @last_move = [start,dest,piece]
  end

  def promote(square, piece)
    color = piece.color
    puts "Congratulations: Your pawn can be promoted. What piece would you like to promote it to?
    Type Q for Queen, N for Knight, B for Bishop, or R for Rook."
    input = ""
    loop do
      input = gets.chomp.upcase
      break if ["Q", "N", "K", "R"].include?(input)
      puts "Please type Q, N, K, or R"
    end
    piece = 
    case input
    when "Q"
      Piece.new("queen",color)
    when "N"
      Piece.new("knight",color)
    when "B" 
      Piece.new("bishop",color)
    when "R"
      Piece.new("rook",color)
    end
    @grid[square] = piece
    puts "Your pawn has been upgraded to a #{piece.type} on #{square}."
  end

  def complete_castle_left(player)
    k = player == "white" ? 1 : 8
    king = @grid["E#{k}"]
    king.moved = true
    @grid["C#{k}"] = king
    @grid["E#{k}"] = nil
    rook = @grid["A#{k}"]
    rook.moved = true
    @grid["D#{k}"] = rook
    @grid["A#{k}"] = nil
    if player == "white"
      @white_king_location == "C1"
    elsif player == "black"
      @black_king_location == "C8"
    end
    puts "#{player.capitalize} castles on the Queen's side."
  end

  def complete_castle_right(player)
    k = player == "white" ? 1 : 8
    king = @grid["E#{k}"]
    king.moved = true
    @grid["G#{k}"] = king
    @grid["E#{k}"] = nil
    rook = @grid["H#{k}"]
    rook.moved = true
    @grid["F#{k}"] = rook
    @grid["H#{k}"] = nil
    if player == "white"
      @white_king_location == "G1"
    elsif player == "black"
      @black_king_location == "G8"
    end
    puts "#{player.capitalize} castles on the Queen's side."
  end

  def print
    hor_line = "  +---+---+---+---+---+---+---+---+"
    display = Array.new
    display << "    A   B   C   D   E   F   G   H"
    display << hor_line
    ("1".."8").each do |row|
      row_print = Array.new
      row_print << "#{row} |"
      ("A".."H").each do |col|
        key = col + row
        if @grid[key].nil?
          row_print << "   |"
        else
          row_print << " #{grid[key].symbol} |"
        end
      end
      display << row_print.join("")
      display << hor_line
    end
    display = display.reverse
    display.each do |line|
      puts line
    end
  end

end