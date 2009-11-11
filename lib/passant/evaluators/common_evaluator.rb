
module Passant
  
  # a common evaluator with values Pawn=1, Knight;Bishop=3, Rook=5, Queen=9
  class CommonEvaluator
    PieceValues = { Pawn   => 1,
                    Knight => 3,
                    Bishop => 3,
                    Rook   => 5,
                    Queen  => 9,
                    King   => 0 }
    
    def initialize(board)
      @board = board
    end
    
    def value
      val = {:white => 0, :black => 0}
      @board.pieces.each{|p| val[p.color] += PieceValues[p.class]}
      val 
    end
  end
  
end
