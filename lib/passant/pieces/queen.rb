require 'passant/piece'

module Passant

  class Queen < Piece  
    def moves(recurse=true)
      linear_moves([[0,1],[1,0],[0,-1],[-1,0],
                   [1,1],[-1,-1],[1,-1],[-1,1]], true, recurse)
    end
  end

end
