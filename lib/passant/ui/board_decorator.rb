require 'passant/game_board'
require 'passant/data/init'
require 'passant/ui/extensions'
require 'passant/ui/common'
require 'passant/ui/highlighter'
require 'forwardable'

module Passant::UI
  
  module BoardDecorator
    extend Forwardable
    attr_reader :pending, :highlighter, :panel
    def_delegators :@panel, :refresh
    
    def create_ui(parent)
      pieces.each{|p| p.initialize_ui(self)}
      
      @white = Passant::UI.bitmapify('white_square.png')
      @black = Passant::UI.bitmapify('black_square.png')
      @flipped = false
      @pending = []
      @highlighter = Highlighter.new(self)
      
      @panel = Wx::Panel.new(parent, :size => [480,480])
      @panel.evt_paint     { self.paint }
      @panel.evt_left_down {|event| self.click_piece(event)   }
      @panel.evt_left_up   {|event| self.release_piece(event) }
      @panel.show
    end
    
    def add_piece(piece)
      super(piece)
      piece.initialize_ui(self)
    end

    def move_abs(from, to)
      mv = super(from, to)
      pending << lambda{ mv.draw(@panel) }
      mv
    end
    
    def move(move_str)
      mv = super(move_str)
      pending << lambda{ mv.draw(@panel) }
      mv
    end
    
    def flipped?; @flipped end

    def flip
      @flipped = !@flipped
      paint
    end
    
    def draw_square(pos, dc)
      x = flipped? ? 7 - pos[0] : pos[0]
      y = flipped? ? pos[1] : 7 - pos[1]
      square = (x+y) % 2 == 0 ? @white : @black

      dc.draw_bitmap(square, x*60, y*60, true)
    end

    def paint
      @panel.paint do |dc|
        8.times do |x|
          8.times do |y|
            draw_square([x,y],dc)
          end
        end
        pieces.each {|p| p.draw(dc) }
        @highlighter.highlight(dc)
      end
    end
    
    def draw_pending
      while pending_draw = @pending.delete_at(0)
        pending_draw.call
      end
    end
    
    def point_for_pos(pos)
      x = flipped? ? 420 - (pos[0] * 60) : pos[0]*60
      y = flipped? ? pos[1] * 60 : 420 - (pos[1]*60)
      Wx::Point.new(x,y)
    end

    def pos_for_point(point)
      x = flipped? ? 7 - (point.x / 60) : point.x / 60
      y = flipped? ? point.y / 60 : 7 - (point.y / 60)
      [x,y]
    end

    #### Mouse actions ####
    def click_piece(mouse_event)
      @from = pos_for_point(mouse_event.get_position)
    end
    
    def release_piece(mouse_event)
      return unless @from
      
      Wx::get_app.responsively do
        begin
          to = pos_for_point(mouse_event.get_position)
          @panel.disable
          mv = move_abs(@from, to)
          pending << lambda {@panel.parent.set_status(mv.to_pgn)}
          
        rescue Passant::MoveParser::ParseError, Passant::Board::Exception => e
          pending << lambda {@panel.parent.set_status(e.message)}
        
        ensure  
          @from = nil
          @panel.enable
        end
      end
    end
    
  end
  
end