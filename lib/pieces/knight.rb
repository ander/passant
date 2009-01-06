require File.dirname(__FILE__)+"/../piece"

class Knight < Piece
  def moves(recurse=true)
    mvs = []
    [[x+1,y+2], [x+2,y+1], [x+2,y-1], [x+1,y-2],
     [x-1,y-2], [x-2,y-1], [x-2,y+1], [x-1,y+2]].each do |to|
      mv = Move.new(self, to)
      if !@board.off_limits?(to) and @board.rules.valid_move?(mv, true, recurse)
        mvs << mv
      end
    end
    mvs
  end

end
