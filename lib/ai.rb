=begin rdoc

An experimental minimaxing AI using memcached to store data.

TODO: actually use the memcached
TODO: alpha-beta pruning

=end

require 'rubygems'
require 'memcache'
require 'benchmark'
require File.dirname(__FILE__)+"/board"

class AI
  MaxDepth = 1
  PieceValues = {Pawn   =>   1,
                 Knight =>   3,
                 Bishop =>   3,
                 Rook   =>   5,
                 Queen  =>   9,
                 King   => 100}

  def initialize(board)
    @board = board
    @cache = MemCache.new('localhost')
    set_values
  end

  def move(color)
    Benchmark.measure do
      result = send("#{color}_value".to_sym, @board, 0)
      puts "Best value: #{result[0]} (#{result[1]})"
      result[1].apply
    end
  end

  private

  def set_values
    PieceValues.each do |piece ,val|
      piece.class_eval %Q(def value; #{val}; end)
    end
    Board.class_eval( 
      %Q(def value 
           @pieces.inject(0){|sum,p| sum += (p.value)*p.advance_direction}
         end))
  end

  ### Minimaxing ###
  def white_value(board, depth, move=nil)
    return [board.value, move] if depth > MaxDepth
    max = [-1000, nil]
    board.all_moves(:white).each do |mv|
      b = board.after_move(mv)
      x = black_value(b, depth+1, mv)
      max = [x[0],mv] if x[0] > max[0]
    end
    return max
  end
  
  def black_value(board, depth, move=nil)
    return  [board.value, move] if depth > MaxDepth
    max = [1000, nil]
    board.all_moves(:black).each do |mv|
      b = board.after_move(mv)
      x = white_value(b, depth+1, mv)
      max = [x[0],mv] if x[0] < max[0]
    end
    return max
  end
  ###
end
