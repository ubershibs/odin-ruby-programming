class Game
attr_reader :board, :player1, :player2, :winner, :current_turn

@@winning_lines = 
    [[0, 1 ,2], 
     [3, 4, 5], 
     [6, 7, 8], 
     [0, 3, 6], 
     [1, 4, 7], 
     [2, 5, 8], 
     [0, 4, 8], 
     [2, 4, 6]]

  def initialize
    @board = Board.new
    @player1 = Player.new("X")
    @player2 = Player.new("O")
    @winner = nil
    @current_turn = 1
  end

  def game_agenda
    welcome_msg
    play
    results_msg
  end

  def welcome_msg
    puts "Welcome to TicTacToe!"
    puts "Player 1 is X. Player 2 is O. You're up, player 1!"
    puts "Here's the current grid. I'll add your Xs and Os as we go."
    @board.print_grid
  end

  def play
    take_turns until game_ends
  end

  def game_ends
    @current_turn > 9 || @winner
  end

  def take_turns
    @current_turn % 2 != 0 ? turn(@player1) : turn(@player2)
  end

  def turn(player)
    selection = get_valid_cell(player)
    if @board.update_grid(selection, player)
      @current_turn += 1
    else
      error = "Sorry, that cell is invalid"
    end
    @board.print_grid
    puts error
    check_for_winner(player)
  end

  def get_valid_cell(player)
    selection = nil
    until (0..8).include?(selection)
      puts "#{player.marker}: select an empty cell (1-9 from the top left)"
      selection = gets.chomp.to_i - 1
    end
    selection
  end

  def check_for_winner(player)
    @@winning_lines.each do |line|
      @winner = player if line.all? { |a| @board.board[a] == player.marker }
    end
  end

  def results_msg
    puts "Game over!"
    if @current_turn > 9 && @winner == nil
      puts "It's a tie."
    else
      puts "Congrats, #{@winner.marker}. You win!"
    end
  end

  class Board
    attr_reader :board


    def initialize
      @empty = " "
      @board = Array.new(9, @empty)
    end

    def update_grid(selection, player)
      if @board[selection] == @empty
        @board[selection] = player.marker
        return true
      else
        return false
      end
    end

    def print_grid
      @board.each_slice(3) { |row| puts row.join(" | ")}
    end
  end

  Player = Struct.new(:marker)
end

#game = Game.new
#game.game_agenda
