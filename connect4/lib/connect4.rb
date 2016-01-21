#lib/connect4.rb
require 'colorize'

class Connect4

  WELCOME = 
  "\t**********************
  \r\t**                  **
  \r\t**    Connect 4!    **
  \r\t**                  **
  \r\t**********************"

  attr_accessor :p1, :p2, :board, :current_player, :turn, :winner

  def initialize
    @p1 = Player.new(:red)
    @p2 = Player.new(:blue)
    @board = Board.new
    @turn = set_turn(1)
    @winner = nil
  end
  
  def set_turn(i)
    @turn = i.to_i
  end

  def play
    puts WELCOME
    take_turns
    @board.display_board
    end_game_msg
  end

  def take_turns
    while game_over? == false
      @board.display_board
      @board.place_piece(current_player, get_valid_input)
      @turn += 1
    end
  end

  def game_over?
    return true if horizontal_win?
    return true if vertical_win?
    return true if diag_win_left?
    return true if diag_win_right?
    return true if draw?
    false
  end

  def end_game_msg
    if @winner == :draw
      puts "Game over. It's a draw."
    else
      puts "Congratulations, #{@winner.color.capitalize}! You win!"
    end
  end

  def current_player
    current = @turn % 2 == 0 ? @p2 : @p1
    current
  end

  def get_input(prompt)
    loop do 
      print prompt + ": "
      input = gets.chomp
      return input unless input.empty? 
    end
  end

  def get_valid_input
    loop do
      prompt = "#{current_player.color.capitalize}, enter the column to play"
      input = get_input(prompt)
      return input.to_i - 1 if valid_input?(input)
    end
  end

  def valid_input?(input)
    input_adj = input.to_i - 1
    if input_adj.between?(0,6) == false
      puts "#{input} is not a valid column."
      return false
    end
    if @board.col_full?(input_adj)
      puts "Column #{input} is full."
      return false
    end  
    true
  end

  def draw?
    if @turn > 42
      @winner = :draw
    end
  end

  def horizontal_win?
    check_board(0, 3, 0, 5, [1,0])
  end

  def vertical_win?
    check_board(0, 6, 0, 2, [0,1])
  end

  def diag_win_left?
    check_board(3, 6, 0, 2, [-1, 1])
  end

  def diag_win_right?
    check_board(0, 3, 0, 2, [1, 1])
  end

  def check_board(start_col, end_col, start_row, end_row, change)
    (start_col..end_col).each do |col|
      (start_row..end_row).each do |row|
        if @board.grid[col][row] != :blank
          if same_piece_in_each?(line_from([col, row], change))
            @winner = @board.grid[col][row]
            return true
          end
        end
      end
    end
    return false
  end

  def line_from(start_position, change)
    positions = [start_position]
    3.times do 
      positions << increment_pos(positions.last, change)
    end
    positions
  end

  def increment_pos(position1, position2)
    [position1[0] + position2[0], position1[1] + position2[1]]
  end

  def same_piece_in_each?(positions)
    values = positions.map { |p| @board.grid[p.first][p.last] }
    return nil if values.uniq == :blank
    values.uniq.length == 1
  end
end

class Player
  attr_accessor :color

  def initialize(color)
    @color = color
  end

end

class Board
  PIECE = "\u2689"
  COLS = 7
  ROWS = 6

  attr_accessor :grid

  def initialize
    @grid = Array.new
    setup_empty
  end

  def setup_empty
    @grid = []
    COLS.times do
      blank_col = []
      ROWS.times { blank_col << :blank }
      @grid << blank_col
    end
  end

  def col_full?(column)
    return true if @grid[column][5] != :blank
    false
  end

  def place_piece(piece, column)
    first_empty_row = @grid[column].index(:blank)
    @grid[column][first_empty_row] = piece
  end

  def display_board
    puts "Current board:"
    puts "\t   1  2  3  4  5  6  7 "
    5.downto(0) do |row|
      output = []
      output << "\t"
      output << "#{row+1} "
      0.upto(6) do |col|
        if @grid[col][row] == :blank
          output << " #{PIECE} ".colorize(:light_white)
        elsif @grid[col][row].color == :red
          output << " #{PIECE} ".colorize(:red)
        elsif @grid[col][row].color == :blue
          output << " #{PIECE} ".colorize(:blue)
        end
      end
      puts output.join("")
    end
  end
end

#game = Connect4.new
#game.play