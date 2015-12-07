class SecretCode
  attr_reader :solved, :results

  def initialize
    @code = Array.new
    @solved = false
    @results = []
    generate_code
  end

  def compare(guess)
    exact_matches = 0
    inexact_matches = 0
    other_matches = 0
    @code.each_index { |i| exact_matches += 1 if @code[i] == guess[i] }
    @code.each { |n| inexact_matches += 1 if guess.include?(n) }
    if exact_matches == 4
      @solved = true
    end
    other_matches = inexact_matches - exact_matches
    @results = [exact_matches, other_matches]
    return @results
  end

  def generate_code
    peg = Random.new
    4.times do 
      peg = rand(0..5)+65
      @code << peg.chr
    end
  end
end

class Game
  attr_reader :turn, :solved, :secret

  def initialize
    @turn = 0
    @secret = SecretCode.new
    @board = Hash.new
    @game_over = false
  end

  def play
    instructions
    make_guesses until @game_over == true
  end

  def make_guesses
    guess
    print_board
    is_game_over
  end

  def guess
    puts "What's your next guess?"
    guess = gets.chomp.upcase.split(//)
    results = @secret.compare(guess)
    @board[@turn+1] = {
      "guess" => guess,
      "results" => results
    }
    @turn += 1
  end

  def is_game_over
    if @secret.solved == true
      puts "CODE FOUND!!"
      puts "Congrats! You win! Game over."
      @game_over = true
    elsif @turns == 12
      puts "Out of turns"
      @game_over = true
    else
      @game_over = false
    end
  end

  def instructions
    puts "Welcom to Mastermind!"
    puts "For now, I've decided to create a four-letter code instead of colored pegs." 
    puts "I have only use  the letters A, B, C, D, E & F. I may use the same letter more than once."
    puts "I will respond to each guess letting you know how closely your responses matches"
    puts "EXACT matches = right letter & position"
    puts "INEXACT matches = right letter, wrong position"
    puts " "
  end
  
  def print_board
    puts "Current board:"
    puts "\#: Guess, [Exact, Inexact]"
    @board.each {|k,v| puts "#{k}: #{v}"}
    puts " "
  end
end

game = Game.new
game.play
