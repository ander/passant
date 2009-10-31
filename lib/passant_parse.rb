# Parse all games in a pgn file to get some data to db
# Run with ruby -rubygems on ruby 1.8.x to load the sqlite3 gem
# Give the file as argument.

require 'passant/game_board'
require 'passant/data/init'

f = Passant::PGN::File.new(ARGV.first)

puts "Parsing PGN with #{f.games.size} games.."

f.games.each do |g|
  puts "Parsing #{g.title}.."
  g.to_board
end
  
puts "Done."

