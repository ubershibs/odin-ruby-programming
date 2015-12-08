module Mastermind

  def validate_code(code)
    good_range = 0
    if code.length == 4
      code.each { |n| good_range += 1 if n.between?("A","F") }
      if good_range != 4
        puts "You can only use the letters A through F."
        return false
      else
        return true
      end
    else
      puts "Codes must be exactly 4 charaters"
      return false
    end
  end
  
end

class SecretCode
  include Mastermind
  attr_reader :solved, :results

  def initialize
    @code = Array.new
    @solved = false
    @results = []
  end

  def choice
    c = nil
    until c == "C" || c == "H"
      puts "Who selects the code? Type H for human or C for computer."
      c = gets.chomp.upcase.chr
    end
    c=="C" ? generate_code : select_code
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

  private
  def select_code
    until validate_code(@code) == true
      puts "Input the secret code of your choice. It must be 4 letters. Use only letters A-F."
      @code = gets.chomp.upcase.split(//)
    end
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
  include Mastermind
  attr_reader :turn, :solved, :secret

  def initialize
    @turn = 0
    @secret = SecretCode.new
    @board = Hash.new
    @game_over = false
  end

  def play
    welcome
    @secret.choice
    instructions
    while @game_over != true
      make_guesses
    end
  end

  def make_guesses
    guess
    print_board
    is_game_over
  end

  def guess
    guess = []
    until validate_code(guess) == true
      puts "What's your next guess?"
      guess = gets.chomp.upcase.split(//)
    end
    results = @secret.compare(guess)
    @board[@turn+1] = {
      :guess => guess,
      :results => results
    }
    @turn += 1
  end

  def is_game_over
    if @secret.solved == true
      puts "CODE FOUND!!"
      puts "Congrats! You win! Game over."
      @game_over = true
    elsif @turn == 12
      puts "Out of turns. Game over."
      @game_over = true
    else
      @game_over = false
    end
  end

  def welcome
    puts "Welcome to Mastermind!"
  end

  def instructions
    puts "For now, I've decided to create a four-letter code instead of colored pegs." 
    puts "I have only used the letters A, B, C, D, E & F. I may use the same letter more than once."
    puts "I will respond to each guess letting you know how closely your responses matches"
    puts "EXACT matches = right letter & position"
    puts "INEXACT matches = right letter, wrong position"
    puts " "
  end
  
  def print_board
    puts "Current board:"
    @board.each {|k,v| puts "Turn #{k}. Guess: #{v[:guess].join(", ")} | Exact matches #{v[:results][0]} | Other matches: #{v[:results][1]}"}
    puts " "
  end
end

game = Game.new
game.play
