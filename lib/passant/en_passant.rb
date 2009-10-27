
module Passant
  
  # En passant.
  class EnPassant < Move
  
    def initialize(pawn, to)
      @piece = pawn
      @from = @piece.position
      @to = to
      @capture_piece = \
        @piece.board.at([@to[0], @to[1] - @piece.advance_direction])
    end
  
    def capture?; true; end

    def to_s
      l = @piece.board.letter_for_piece(@piece)
      "#{l}#{chess_coords(@from)}x#{chess_coords(@to)}"
    end
    
  end

end
