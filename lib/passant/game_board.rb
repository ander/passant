
require 'passant/board'
require 'passant/pgn'

module Passant
  
  # A board with alternating turns for white and black.
  class GameBoard < Board
    
    attr_reader :turn
    include Passant::PGN::Support
    
    def initialize
      super(Board::InitialPosition)
    end
    
    def reset
      super
      @turn = :white
      self.tag_pairs = PGN::TagPair.required
    end
    
    def set(board_data, turn=:white)
      super(board_data)
      @turn = turn
    end
    
    # can also be called after the game is over
    def move(from, to=nil)
      mv = Move.parse(self, @turn, from, to)
      
      piece = self.at(mv.from)
      if piece.color != @turn
        raise Board::Exception.new("#{@turn.to_s.capitalize}'s turn!")
      end
      
      mv.apply
      
      @turn = opponent(@turn)
      mv
    end
    
    def take_back
      mv = super    
      @turn = opponent(@turn) if mv
      mv
    end

    def undo_takeback
      mv = super
      @turn = opponent(@turn) if mv
      mv
    end
    
  end
end
