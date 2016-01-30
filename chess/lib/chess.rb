# lib/chess.rb 

require 'yaml'

class Chess

  attr_reader :board, :turn

  def initialize
    @board = Board.new
    @turn = 1
  end

  def save
    Dir.mkdir("saves") unless Dir.exists? ("saves")
    File.open("saves/saved.yaml", "w") do |file|
      file.write(YAML::dump(self))
    end
    puts "Game saved for later! Come back soon!"
    exit
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
    elsif input == "SAVE"
      save
    elsif input == "EXIT"
      exit
    else
      puts "Valid moves look like this: A8 H1. To save your game, type SAVE. Try again."
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
      @board.print
      king_loc = @board.king_locator(curr_player)
      if @board.in_check?(curr_player, king_loc) 
        puts "You are in check. You move resolve the check to complete your turn."
      end
      move = input
      move_ary = parse_move(move)
      moved = @board.check_move(move_ary, curr_player)
    end
    @turn += 1
  end

  def play
    loop do
      break if @board.checkmate?(curr_player) == true
      break if @board.stalemate?(curr_player) == true
      turn
    end
    if @board.checkmate?(curr_player)
      other player = curr_player == "white" ? "black" : "white"
      "Checkmate on #{curr_player}. #{other_player.capitalize} wins!"
      exit
    elsif @board.stalemate?(currplayer)
      "Stalemate! #{curr_player} has no legal moves"
      exit
    end
  end
end



