require 'passant/piece'

module Passant
  
  class Rook < Piece
    def moves(opts={:recurse => true})
      linear_moves([[-1,0],[1,0],[0,-1],[0,1]], true, opts[:recurse])
    end
  end
  
end
