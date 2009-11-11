
module Passant
  
  # a standard evaluator with values Pawn=1, Knight;Bishop=3, Rook=5, Queen=9
  class StandardEvaluator
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
    
    def value_str
      val = self.value
      "Material: #{val[:white]} / #{val[:black]}"
    end
    
  end
  
end
