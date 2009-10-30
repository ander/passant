require 'passant/piece'
require 'passant/pieces/queen'

module Passant
  class Pawn < Piece
    @@white_promotion_piece = @@black_promotion_piece = Queen
    
    def moves(recurse=true)
      mvs = []

      # one square advance
      if [0,7].include?(y+advance_direction)
        move_class = Promotion
      else
        move_class = Move
      end    
      mv1 = move_class.new(self, [x, y+advance_direction])
      mvs.push(mv1) if @board.valid_move?(mv1, false, recurse)
    
      # two squares advance
      mv2 = Move.new(self, [x, y+2*advance_direction])
      mvs.push(mv2) if !self.moved? and \
                       !@board.off_limits?([x, y+2*advance_direction]) and \
                       @board.valid_linear_move?(mv2, false, recurse)
    
      # capture 1
      c1 = move_class.new(self, [x+1, y+advance_direction])
      mvs.push(c1) if self.enemy?(@board.at([x+1, y+advance_direction])) and \
                      @board.valid_move?(c1, true, recurse)

      # capture 2
      c2 = move_class.new(self, [x-1, y+advance_direction])
      mvs.push(c2) if self.enemy?(@board.at([x-1, y+advance_direction])) and \
                      @board.valid_move?(c2, true, recurse)
    
      # en passant
      ep = @board.en_passant(self)
      mvs.push(ep) if ep
      mvs
    end
  
    def self.promotion_piece(color)
      case color
      when :white
        @@white_promotion_piece
      when :black
        @@black_promotion_piece
      end
    end
    
    def self.set_promotion_piece(color, piece_class)
      case color
      when :white
        @@white_promotion_piece = piece_class
      when :black
        @@black_promotion_piece = piece_class
      end
    end
  
  end

end
