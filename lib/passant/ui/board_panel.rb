
require 'passant/game_board'
require 'passant/ui/extensions'
require 'passant/ui/common'

module Passant::UI
  class BoardPanel < Wx::Panel
    attr_accessor :board
    
    def initialize(parent)
      super(parent, :size => [480,480])
      evt_paint     :paint_board
      evt_left_down :click_piece
      evt_left_up   :release_piece
      
      set_board Passant::GameBoard.new
      @white = Passant::UI.bitmapify('white_square.png')
      @black = Passant::UI.bitmapify('black_square.png')
      @flipped = false
      show
    end
    
    def flipped?; @flipped end

    def flip_board
      @flipped = !@flipped
      paint_board
    end

    def set_board(board)
      @board = board
      @board.ui = self
    end
    
    def draw_square(pos, dc)
      x = pos[0]
      y = flipped? ? pos[1] : 7 - pos[1]
      square = (x+y) % 2 == 0 ? @white : @black

      dc.draw_bitmap(square, x*60, y*60, true)
    end

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

    private

    def pos_for_point(point)
      x = point.x / 60
      y = flipped? ? (point.y / 60) : (7 - (point.y / 60))
      [x,y]
    end

    #### Mouse actions ####
    def click_piece(mouse_event)
      @from = pos_for_point(mouse_event.get_position)
    end
    
    def release_piece(mouse_event)
      return unless @from
      to = pos_for_point(mouse_event.get_position)
      
      if !to.nil?
        self.disable
        Wx::get_app.responsively do
          begin
            mv = @board.move(@from, to)
            parent.set_status(mv.to_s)
          rescue Passant::Move::Invalid, Passant::Board::Exception => e
            parent.set_status(e.message)
          end
        end
      end
      
      @from = nil
      self.enable
    end
    
  end
end
