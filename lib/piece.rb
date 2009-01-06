=begin rdoc

Base class for chess pieces.

=end

require File.dirname(__FILE__)+"/move"

class Piece
  attr_accessor :position, :history
  attr_reader :board, :color
  
  def initialize(board, position, color=:white)
    @board = board
    @position = position
    @color = color
    @history = []
    @board.add_piece(self)
  end
  
  def x; @position[0]; end
  def y; @position[1]; end
  
  def moves(recurse=true)
    raise "Define moves by overriding #moves (#{self.class})!"
  end
  
  # return true if this piece has been moved
  def moved?; !@history.empty?; end
  
  def advance_direction
    color == :white ? 1 : -1
  end
  
  def enemy_color
    color == :white ? :black : :white
  end

  def enemy?(piece)
    piece.color == enemy_color
  end

  def linear_moves(dirs, can_capture=true, recurse=true)
    mvs = []
    dirs.each do |dir|
      mv = Move.new(self, [@position[0]+dir[0], @position[1]+dir[1]])
      while !@board.off_limits?(mv.to) and \
        @board.rules.valid_linear_move?(mv, can_capture, recurse)
        mvs << mv
        mv = Move.new(self, [mv.to[0]+dir[0], mv.to[1]+dir[1]])
      end
    end
    mvs
  end

  def captured!
    @board.remove_piece(self)
  end

end
