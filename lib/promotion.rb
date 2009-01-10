=begin rdoc

Pawn promotion.

=end

class Promotion < Move
  def initialize(piece, move_to)
    super
    @promo_piece = Pawn.promotion_piece(:white)
  end
  

  def apply
    super
    @piece.board.remove_piece(@piece)
    @piece.board.add_piece(@promo_piece.new(@piece.board,
                                            @piece.position,
                                            @piece.color))
  end

  def capture?; false; end

  def to_s
    super + "=" + 
      @piece.board.letter_for_piece_class_and_color(@promo_piece,
                                                    @piece.color)
  end
  
end
