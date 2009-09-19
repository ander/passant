
require 'passant/board'

module Passant
  
  # A board with alternating turns for white and black 
  class GameBoard < Board
    def initialize(position=Board::InitialPosition)
      super
      @turn = :white
    end
    
    # TODO
    def move(from, to)
      super
    end
    
  end
end
