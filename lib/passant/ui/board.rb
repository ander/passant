
require 'passant/board'
require 'passant/ui/extensions'
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
      evt_paint     :paint_board
      evt_left_down :click_piece
      evt_left_up   :release_piece

      set_board Passant::Board.new
      @white = Passant::UI.bitmapify('white_square.png')
      @black = Passant::UI.bitmapify('black_square.png')
      
      show
    end
    
    def set_board(board)
      @board = board
      @board.ui = self
    end
    
    def draw_square(pos, dc)
      x = pos[0]
      y = 7 - pos[1]
      square = (x+y) % 2 == 0 ? @white : @black

      dc.draw_bitmap(square, x*60, y*60, true)
    end
    
    private

    def paint_board
      paint do |dc|
        8.times do |x|
          8.times do |y|
            draw_square([x,y],dc)
          end
        end
        @board.pieces.each {|p| p.draw(dc) }
      end
    end

    def pos_for_point(point)
      x = point.x / 60
      y = 7 - (point.y / 60)
      [x,y]
    end

    #### Mouse actions ####
    def click_piece(mouse_event)
      @piece = @board.at(pos_for_point(mouse_event.get_position))
    end
    
    def release_piece(mouse_event)
      return unless @piece
      
      mv = @piece.moves.detect do |m| 
        m.to == pos_for_point(mouse_event.get_position)
      end
      
      mv.apply_with_ui if mv
      
      @piece = nil
    end
    
  end
  
end
