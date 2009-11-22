require 'passant/piece'

module Passant

  class Queen < Piece  
    def moves(opts={:recurse => true})
      linear_moves([[0,1],[1,0],[0,-1],[-1,0],
                   [1,1],[-1,-1],[1,-1],[-1,1]], true, opts[:recurse])
    end
  end

end
