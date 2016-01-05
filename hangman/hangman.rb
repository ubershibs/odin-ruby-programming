require 'yaml'

class Game

  def initialize
    @secret_word = draw_word.split(//)
    @game_board = Array.new(@secret_word.length, "_")
    @empty_spaces = @game_board.length
    @misses_left = 7
    @misses = Array.new(@misses_left, "_")
    play
  end

  def save
    Dir.mkdir("saves") unless Dir.exists? ("saves")
    File.open("saves/saved.yaml", "w") do |file|
      file.write(YAML::dump(self))
    end
    puts "Game saved!"
    exit
  end

  def play
    puts "I've chosen a secret word. Guess one letter per turn. You get one step close to hanging with each missed letter."
    puts "The game is over when solve the puzzle, or after 7 incorrect guesses. \n"

    until @misses_left == 0 || @empty_spaces == 0
      turn
    end

    determine_ending
  end

  def turn
    guess = ""
    puts "Secret Word: #{@game_board.join(" ")}"
    puts "Misses: #{@misses.join(" ")} \n"
    
    until validate_guess(guess) == true
      puts "Guess a letter or type 'save' to save for later."
      guess = gets.chomp.downcase 
    end

    check_guess(guess)
  end

  private
  def draw_word
    filename = "5desk.txt"
    secret_word = File.readlines(filename).sample.chomp.downcase until secret_word.to_s.length.between?(5, 12)
    secret_word
  end

  def validate_guess(guess)
    if guess == "save"
      save
    elsif @misses.include?(guess) == true || @game_board.include?(guess) == true
      puts "You've already guessed that letter."
      return false
    elsif !(guess =~ /[a-z]/)
      puts "You can only uses letters (a-z) to guess."
      return false
    elsif !(guess.length == 1)
      puts "You can only guess one letter at a time."
      return false
    else
      return true
    end
  end

  def check_guess(guess)
    guess_matches = Array.new(0)

    @secret_word.each_with_index do |letter, i|
      guess_matches << i if letter == guess
    end
      
    if guess_matches.empty?  
      miss_index = 7 - @misses_left
      @misses_left -= 1
      @misses[miss_index] = guess
      puts "Sorry, no #{guess} in the secret word. Only #{@misses_left} misses left.\n" 
    else
      guess_matches.each do |card|
        @game_board[card] = guess
        @empty_spaces -= 1
      end
      puts "Right on! Getting closer - #{guess_matches.length} letter #{guess} found.\n"
    end
  end

  def determine_ending
    puts "Congratulations! You've win. The word is #{@secret_word.join('')}" if @empty_spaces == 0
    puts "Out of guesses. Better luck next time!" if @misses_left == 0
  end

end

def load
  if File.exists?("saves/saved.yaml")
    saved_game = YAML::load(File.read("saves/saved.yaml"))
    saved_game.play
  else
    puts "No saved games yet"
  end   
end

puts "Welcome to Hangman!"
puts "Would you like to load a saved game? y/n"
choice = gets.chomp

game = case choice
  when "n" then Game.new
  when "y" then load
end