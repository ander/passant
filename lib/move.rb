=begin rdoc

Move of a piece.

=end

class Move
  attr_reader :piece, :from, :to
  
  def initialize(piece, move_to)
    @piece = piece
    @from = piece.position
    @to = move_to
  end

  def capture?
    !@piece.board.at(@to).nil?
  end

  def apply
    if p = @piece.board.at(@to)
      p.capture!
    end
    @piece.position = @to
    @piece.history << self
    @piece.board.history << self
  end
  
  def take_back
    # ...
  end

  def to_s
    l = @piece.board.letter_for_piece(@piece)
    c = capture? ? 'x' : ''
    "#{l}#{chess_coords(@from)}#{c}#{chess_coords(@to)}"
  end

  def inspect; to_s; end
  
end
