require 'passant/piece'

module Passant
  
  class King < Piece
    def moves(recurse=true, include_castlings=true)
      mvs = []
      [[x+1,y], [x-1,y], [x,y+1], [x,y-1],
       [x+1,y+1], [x-1,y-1], [x-1,y+1], [x+1,y-1]].each do |to|
        mv = Move.new(self, to)
        if !@board.off_limits?(to) and @board.valid_move?(mv, true, recurse)
          mvs << mv
        end
      end
      mvs += @board.castlings(self) if include_castlings
      mvs
    end
  
  end

end
