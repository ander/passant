require 'passant/piece'

module Passant
  
  class Knight < Piece
    def moves(opts={:recurse => true})
      mvs = []
      [[x+1,y+2], [x+2,y+1], [x+2,y-1], [x+1,y-2],
       [x-1,y-2], [x-2,y-1], [x-2,y+1], [x-1,y+2]].each do |to|
        mv = Move.new(self, to)
        if !@board.off_limits?(to) and @board.valid_move?(mv, true, opts[:recurse])
          mvs << mv
        end
      end
      mvs
    end
    
  end

end
