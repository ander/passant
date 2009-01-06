require File.dirname(__FILE__)+"/../piece"

class King < Piece
  def moves(recurse=true)
    mvs = []
    [[x+1,y], [x-1,y], [x,y+1], [x,y-1],
     [x+1,y+1], [x-1,y-1], [x-1,y+1], [x+1,y-1]].each do |to|
      mv = Move.new(self, to)
      if !@board.off_limits?(to) and @board.rules.valid_move?(mv, true, recurse)
        mvs << mv
      end
    end
    mvs += @board.rules.fortifications(self)
    mvs
  end
  
end
