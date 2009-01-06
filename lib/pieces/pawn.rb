require File.dirname(__FILE__)+"/../piece"

class Pawn < Piece
  
  def moves(recurse=true)
    mvs = []
    mv1 = Move.new(self, [x, y+advance_direction])
    mvs.push(mv1) if @board.rules.valid_move?(mv1, false, recurse)
    
    mv2 = Move.new(self, [x, y+2*advance_direction])
    mvs.push(mv2) if !self.moved? and \
                     @board.rules.valid_linear_move?(mv2, false, recurse)
    
    # en passant
    ep = @board.rules.en_passant(self)
    mvs.push(ep) if ep
    mvs
  end
  
end
