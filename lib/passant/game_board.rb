
require 'passant/board'

module Passant
  
  # A board with alternating turns for white and black.
  # Also, raises GameOver exception if checkmate or draw.
  class GameBoard < Board
    class GameOver < Board::Error; end
    
    attr_reader :turn
    
    def initialize
      super(Board::InitialPosition)
      @result = nil
    end
    
    def reset
      super
      @turn = :white
      @result = nil
    end
    
    def set(board_data, turn=:white)
      super(board_data)
      @turn = turn
      @result = nil
      update_result unless board_data == Board::InitialPosition
    end
    
    # can also be called after the game is over
    def move(from, to)
      raise_if_result
      
      if self.at(from).color != @turn
        raise Board::InvalidMove.new("#{@turn.to_s.capitalize}'s turn!")
      end
      
      mv = super
      
      @turn = opponent(@turn)
      update_result
      
      raise_if_result
      mv
    end
    
    def take_back
      super
      @result = nil
      self
    end
    
    private

    def raise_if_result
      raise GameOver.new(@result) if @result
    end
    
    def update_result
      if self.rules.checkmate?(@turn)
        @result = "Checkmate (#{opponent(@turn)} wins)" 
      end
      @result = "Draw" if self.rules.draw?(@turn)
    end
    
    # TODO: refactor
    def opponent(color)
      color = (color == :white ? :black : :white)
    end
    
  end
end
