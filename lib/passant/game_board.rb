
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
    def move(move_str)
      mv = MoveParser.instance.parse(self, @turn, move_str)
      
      piece = self.at(mv.from)
      if piece.color != @turn
        raise Board::Exception.new("#{@turn.to_s.capitalize}'s turn!")
      end
      
      mv.apply
      
      @turn = opponent(@turn)
      mv
    end
    
    # Move using absolute from and to squares
    def move_abs(from, to)
      piece = self.at(from)
      
      if piece.color != @turn
        raise Board::Exception.new("#{@turn.to_s.capitalize}'s turn!")
      end
      
      mv = piece ? piece.move_leading_to(to) : nil
      if mv
        mv.apply
        @turn = opponent(@turn)
        mv
      else
        raise Exception.new("Invalid move: from #{from} to #{to}")
      end
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
