=begin rdoc

Castling.

=end

class Castling < Move
  
  def initialize(king, ctype)
    raise "King required" unless king.is_a?(King)
    raise "Invalid castling" unless [:short, :long].include?(ctype)
    @piece = king
    @from = @piece.position
    @ctype = ctype
    
    row = (king.white? ? 0 : 7)
    
    if @ctype == :long
      @to = [2,row]
      @rook = @piece.board.at([0,row])
      @rook_to = [3,row]
    else
      @to = [6,row]
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
    @ctype == :long ? "x-x-x" : "x-x"
  end

end
