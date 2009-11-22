require 'passant/piece'

module Passant
  class Bishop < Piece
  
    def moves(opts={:recurse => true})
      linear_moves([[-1,-1],[1,1],[-1,1],[1,-1]], true, opts[:recurse])
    end
  
  end
end
