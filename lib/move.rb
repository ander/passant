=begin rdoc

Move of a piece.

=end

class Move
  attr_reader :piece, :from, :to
  
  def initialize(piece, move_to)
    @piece = piece
    @from = piece.position
    @to = move_to
    @capture_piece = @piece.board.at(@to)
  end

  def capture?
    !@capture_piece.nil?
  end
  
  def apply
    @capture_piece.capture if @capture_piece
    @piece.position = @to
    @piece.history << self
    @piece.board.history << self
  end
  
  def take_back
    @capture_piece.uncapture if @capture_piece
    @piece.position = @from
    @piece.history.delete(self)
    @piece.board.history.delete(self)
  end
  
  def to_s
    l = @piece.board.letter_for_piece(@piece)
    c = capture? ? 'x' : ''
    "#{l}#{chess_coords(@from)}#{c}#{chess_coords(@to)}"
  end

  def inspect; to_s; end
  
end
