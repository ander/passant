module Passant
  
  # Berliner evaluation of the board. 
  # See http://en.wikipedia.org/wiki/Chess_piece_relative_value
  # Not finished.
  class BerlinerEvaluator
    PieceValues = { Pawn   => 1,
                    Knight => 3.2,
                    Bishop => 3.33,
                    Rook   => 5.1,
                    Queen  => 8.8,
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
      "Berliner: #{val[:white]} / #{val[:black]}"
    end
    
  end
end