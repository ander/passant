require 'passant/ui/common'

module Passant::UI
  
  class Piece
    
    def initialize(piece)
      @piece = piece
      @bitmap = Wx::Bitmap.from_image(
        Wx::Image.new(Passant::UI.img_path(
          "#{piece.color}_#{piece.class.to_s.split('::')[1].downcase}")))
    end
    
    def draw(dc)
      y = ((7 - @piece.y)*60) + 5
      x = (@piece.x * 60) + 10
      dc.draw_bitmap(@bitmap, x, y, true)
    end
    
  end
  
end
