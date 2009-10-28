require 'passant/piece'

module Passant
  class Pawn < Piece
  
    def moves(recurse=true)
      mvs = []

      # one square advance
      if [0,7].include?(y+advance_direction)
        move_class = Promotion
      else
        move_class = Move
      end    
      mv1 = move_class.new(self, [x, y+advance_direction])
      mvs.push(mv1) if @board.rules.valid_move?(@board, mv1, false, recurse)
    
      # two squares advance
      mv2 = Move.new(self, [x, y+2*advance_direction])
      mvs.push(mv2) if !self.moved? and \
                       !@board.off_limits?([x, y+2*advance_direction]) and \
                       @board.rules.valid_linear_move?(@board, mv2, false, recurse)
    
      # capture 1
      c1 = move_class.new(self, [x+1, y+advance_direction])
      mvs.push(c1) if self.enemy?(@board.at([x+1, y+advance_direction])) and \
                      @board.rules.valid_move?(@board, c1, true, recurse)

      # capture 2
      c2 = move_class.new(self, [x-1, y+advance_direction])
      mvs.push(c2) if self.enemy?(@board.at([x-1, y+advance_direction])) and \
                      @board.rules.valid_move?(@board, c2, true, recurse)
    
      # en passant
      ep = @board.rules.en_passant(@board, self)
      mvs.push(ep) if ep
      mvs
    end
  
    def self.promotion_piece(color)
      Queen
    end
  
  end

end
