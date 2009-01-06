require File.dirname(__FILE__)+"/../piece"

class Bishop < Piece
  
  def moves(recurse=true)
    linear_moves([[-1,-1],[1,1],[-1,1],[1,-1]], true, recurse)
  end
  
end
