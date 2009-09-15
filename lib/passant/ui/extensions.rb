require 'passant/ui/common'

# UI extensions to Passant base classes

module Passant

  class Board
    def ui=(ui)
      @ui = ui
      pieces.each{|p| p.initialize_ui(@ui)}
    end
    
    def ui; @ui end

    alias_method :add_piece_without_ui, :add_piece
    
    def add_piece(piece)
      add_piece_without_ui(piece)
      piece.initialize_ui(@ui) if @ui
    end
  end
  
  class Move
    
    def apply_with_ui
      apply
      return unless ui = @piece.board.ui
      
      ui.paint do |dc|
        ui.draw_square(from, dc)
        ui.draw_square(to, dc)
        ui.draw_square(@rook_from, dc) if @rook_from # castlings
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
      y = ((7 - self.y)*60) + 5
      x = (self.x * 60) + 10
      dc.draw_bitmap(@bitmap, x, y, true)
    end
  end

end

