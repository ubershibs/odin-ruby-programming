require "./lib/chess"
require 'yaml'

def load
  if File.exists?("saves/saved.yaml")
    saved_game = YAML::load(File.read("saves/saved.yaml"))
    saved_game.play
  else
    puts "No saved games yet"
    play
  end   
end

def play
  game = Chess.new
  game.play
end

puts "Welcome to Chess!"
puts "Would you like to load a saved game? y/n"
choice = gets.chomp

game = case choice
  when "n" then play
  when "y" then load
end