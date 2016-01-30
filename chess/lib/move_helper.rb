module MoveHelper

CONVERSIONS = ["NA", "A", "B", "C", "D", "E", "F", "G", "H"]

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
    elsif piece.type == "king"
      calc_moves_king(piece, x, y)
    elsif piece.type == "knight"
      calc_moves_knight(piece, x, y)
    else
      return false
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

  def calc_moves_king(piece, x, y)
    directions = [[1,0], [-1,0], [0,1], [0,-1], [1,1], [1,-1], [-1,1], [-1,-1]]
    piece.possible_moves = calc_moves_with_directions(piece, x, y, directions)
    castle_eligible?(piece)
  end

  def calc_moves_knight(piece, x, y)
    directions = [[2,1], [2,-1], [-2,1], [-2,-1], [1,2], [1,-2], [-1,2], [-1,-2]]
    piece.possible_moves = calc_moves_with_directions(piece, x, y, directions)
  end

  def calc_moves_with_directions(piece, x, y, directions)
    moves = Array.new
    directions.each do |dir|
      new_x = x + dir[0]
      new_y = y + dir[1]
      if new_x.between?(1,8) && new_y.between?(1,8)
        key = get_key(new_x, new_y)
        square = @grid[key]
        if square.nil?
          moves << key
        elsif square.color != piece.color
          moves << key
        end
      end
    end
    moves
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
    en_passant(piece, x, y)
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

  def en_passant(piece, x, y)
    return false if @last_move == []
    last_start, last_dest, last_piece = @last_move
    if last_piece.type == "pawn" && (last_dest[1].to_i - last_start[1].to_i).abs == 2
      x_opp, y_opp = get_coordinates(last_dest)
      if (x_opp == x + 1 || x_opp == x - 1) && y == y_opp
        if piece.color == "white"
          y_new = y + 1
          key = get_key(x_opp, y_new)
          piece.possible_moves << key
        elsif piece.color == "black"
          y_new = y - 1
          key = get_key(x_opp, y_new)
          piece.possible_moves << key
        end
      end
    end
  end

  def castle_eligible?(piece)
    if piece.moved == false
      if piece.color == "white"
        castle_left("A1", "white")
        castle_right("H1", "white")
      elsif piece.color == "black"
        castle_left("A8", "black")
        castle_right("H8", "black")
      end
    end
  end

  def castle_left(key,color)
    rook = @grid[key]
    if rook.moved == false
      ary = ["B#{key[1]}","C#{key[1]}","D#{key[1]}"]
      if check_empty(ary)==true
        ("C".."E").each do |letter|
          king_loc = "#{letter}#{key[1]}"
          if in_check?(color, king_loc)
            break
          end
        end
      end
      @grid["E#{key[1]}"].possible_moves << "C#{key[1]}" 
    end
  end

   def castle_right(key,color)
    rook = @grid[key]
    if rook.moved == false
      ary = ["F#{key[1]}","G#{key[1]}"]
      if check_empty(ary)==true
        ("F".."G").each do |letter|
          king_loc = "#{letter}#{key[1]}"
          if in_check?(color, king_loc)
            break
          end
        end 
      end
      @grid["E#{key[1]}"].possible_moves << "G#{key[1]}"
    end
  end

  def check_empty(ary)
    ary.each do |key|
      if @grid[key].nil?
        ary.delete(key)
      end
    end
    if ary.empty?
      return true
    else
      return false
    end
  end

end
