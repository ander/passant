require 'passant/ui/common'

# UI extensions to Passant base classes

module Passant
  
  class Move
    def draw
      return unless ui = @piece.board.ui
      
      ui.paint_buffered do |dc|
        ui.draw_square(from, dc)
        ui.draw_square(to, dc)
        
        if self.class == Castling
          ui.draw_square(@rook_from, dc)
          ui.draw_square(@rook_to, dc)
        end
        
        ui.draw_square(@capture_piece.position, dc) if self.class == EnPassant
        participants.each {|p| p.draw(dc)}
      end
    end
    
  end

  class Piece
    
    def initialize_ui(window)
      @bitmap = Passant::UI.bitmapify(
        "#{self.color}_#{self.class.to_s.split('::')[1].downcase}.png")      
    end
    
    def draw(dc)
      return unless self.active?
      flipped = self.board.ui.flipped?
      
      y = ((flipped ? self.y : (7 - self.y))*60) + 5
      x = ((flipped ? (7 - self.x) : self.x)*60) + 10
      dc.draw_bitmap(@bitmap, x, y, true)
    end
  end
  
end

