
require 'passant/board'
require 'passant/pgn'

module Passant
  
  # A board with alternating turns for white and black.
  # Also, raises GameOver exception if checkmate or draw.
  class GameBoard < Board
    class GameOver < Board::Exception; end
    
    attr_reader :turn
    include Passant::PGN::Support
    
    def initialize
      super(Board::InitialPosition)
    end
    
    def reset
      super
      @turn = :white
      @board_result = '*' # kept separate from the PGN result tag,
                          # which is updated only when the game ends
      self.tag_pairs = PGN::TagPair.required
    end
    
    def set(board_data, turn=:white)
      super(board_data)
      @turn = turn
      @board_result = '*'
      update_result unless board_data == Board::InitialPosition
    end
    
    # can also be called after the game is over
    def move(from, to=nil)
      raise_if_result
      
      if !to.nil? # TODO: do this in Move.parse
        piece = self.at(from)
      
        if piece and piece.color != @turn
          raise Board::Exception.new("#{@turn.to_s.capitalize}'s turn!")
        end
      end
      
      mv = Move.parse(self, @turn, from, to)
      mv.apply
      
      @turn = opponent(@turn)
      update_result
      
      raise_if_result
      mv
    end
    
    def take_back
      mv = super
      if mv
        @board_result = '*'
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
      if @board_result != '*'
        self.pgn_result = @board_result
        raise GameOver.new(@board_result)
      end
    end
    
    def update_result
      #if checkmate?(@turn) 
      #  @board_result = (@turn == :black ? '1-0' : '0-1') 
      #end
      #@board_result = '1/2-1/2' if draw?(@turn)
    end
    
  end
end
