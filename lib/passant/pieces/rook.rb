require 'passant/piece'

module Passant
  
  class Rook < Piece
    def moves(recurse=true)
      linear_moves([[-1,0],[1,0],[0,-1],[0,1]], true, recurse)
    end
  end
  
end
