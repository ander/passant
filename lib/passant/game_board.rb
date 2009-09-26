
require 'passant/board'
require 'passant/pgn'

module Passant
  
  # A board with alternating turns for white and black.
  # Also, raises GameOver exception if checkmate or draw.
  class GameBoard < Board
    class GameOver < Board::Exception; end
    
    attr_reader :turn
    include PGN::Support
    
    def initialize
      super(Board::InitialPosition)
    end
    
    def reset
      super
      @turn = :white
      self.result = '*'
    end
    
    def set(board_data, turn=:white)
      super(board_data)
      @turn = turn
      self.result = '*'
      update_result unless board_data == Board::InitialPosition
    end
    
    # can also be called after the game is over
    def move(from, to)
      raise_if_result
      piece = self.at(from)
      
      if piece and piece.color != @turn
        raise Board::InvalidMove.new("#{@turn.to_s.capitalize}'s turn!")
      end
      
      mv = super
      
      @turn = opponent(@turn)
      update_result
      
      raise_if_result
      mv
    end
    
    def take_back
      mv = super
      if mv
        self.result = '*'
        @turn = opponent(@turn)
      end
      mv
    end

    def undo_takeback
      mv = super
      if mv
        update_result
        @turn = opponent(@turn)
        raise_if_result
      end
      mv
    end

    private

    def raise_if_result
      raise GameOver.new(self.result) if self.result != '*'
    end
    
    def update_result
      if self.rules.checkmate?(@turn) 
        self.result = (@turn == :black ? '1-0' : '0-1') 
      end
      self.result = '1/2-1/2' if self.rules.draw?(@turn)
    end
    
    def opponent(color)
      color = (color == :white ? :black : :white)
    end
    
  end
end
