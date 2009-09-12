
require 'passant/board'
require 'passant/ui/piece'
require 'passant/ui/common'

module Passant::UI
  
  # The main frame of the UI is called Board
  class Board < Wx::Frame
    
    def initialize
      super(nil, 
            :title => "Passant", 
            :pos => [150, 25], 
            :size => [480, 480],
            :style => Wx::MINIMIZE_BOX|Wx::MAXIMIZE_BOX|Wx::SYSTEM_MENU|\
                      Wx::CAPTION|Wx::CLOSE_BOX|Wx::CLIP_CHILDREN)
      
      set_board Passant::Board.new
      @bg = Wx::Bitmap.from_image(Wx::Image.new(Passant::UI.img_path('board')))
      evt_paint {|paint_event| paint_board }
      show
    end

    def set_board(board)
      @board = board
      @pieces = board.pieces.map{|p| Piece.new(p)}
    end

    def paint_board
      paint do |dc|
        dc.draw_bitmap(@bg, 0, 0, true)
        @pieces.each {|p| p.draw(dc) }
      end
    end
    
  end
  
end
