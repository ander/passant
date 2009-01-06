=begin rdoc

Castling.

=end

class Castling < Move
  
  def initialize(king, to)
    raise "King required" unless king.is_a?(King)
    
    row = (king.white? ? 0 : 7)
    raise "Invalid castling" unless [[6,row], [2,row]].include?(to)
    
    @piece = king
    @from = @piece.position
    @to = to
    
    if to == [2,row]  # long
      @rook = @piece.board.at([0,row])
      @rook_to = [3,row]
    else
      @rook = @piece.board.at([7,row])
      @rook_to = [5,row]
    end
  end
  
  def apply
    super
    @rook.position = @rook_to
    @rook.history << self
  end
  
  def to_s
    @to[0] == 2 ? 'x-x-x' : 'x-x'
  end

end
