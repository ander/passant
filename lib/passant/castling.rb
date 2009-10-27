
module Passant
  
  # Castling.
  class Castling < Move
  
    def initialize(king, to)
      raise "King required" unless king.is_a?(King)
    
      row = (king.white? ? 0 : 7)
      raise "Invalid castling" unless [[6,row], [2,row]].include?(to)
    
      @piece = king
      @from = @piece.position
      @to = to
      
      if to == [2,row]  # long
        @rook_from = [0, row]
        @rook = @piece.board.at(@rook_from)
        @rook_to = [3,row]
      else
        @rook_from = [7, row]
        @rook = @piece.board.at(@rook_from)
        @rook_to = [5,row]
      end
    end
    
    def apply
      super
      @rook.position = @rook_to
      @rook.history << self
      self
    end

    def take_back
      super
      @rook.position = @rook_from
      @rook.history.delete(self)
      self
    end
    
    def to_s
      @to[0] == 2 ? 'O-O-O' : 'O-O'
    end

    def participants; [@piece, @rook].compact end
    
  end

end # module Passant
