
module Passant::UI

  class Highlighter
    attr_accessor :highlight_last_move, :mark_pawns
    
    def initialize(board)
      @board = board
      @highlight_last_move = true
      @mark_pawns = true
      @hl_pen = Wx::Pen.new(Wx::RED, 3)
    end
    
    def highlight(dc)
      if @mark_pawns
        @board.pieces.select{|p| p.is_a?(Passant::Pawn)}.each do |p|
          if p.passed?
            point = @board.point_for_pos(p.position)
            dc.set_brush(Wx::GREEN_BRUSH)
            dc.draw_circle(point.x+51, point.y+9, 3)
          end
          
          if p.isolated?
            point = @board.point_for_pos(p.position)
            dc.set_brush(Wx::CYAN_BRUSH)
            dc.draw_circle(point.x+51, point.y+15, 3)
          end
        end
      end
      
      if @highlight_last_move and mv = @board.last_move
        square_hl(dc, mv.from)
        square_hl(dc, mv.to)
      end
    end
    
    private
    
    def square_hl(dc, pos)
      point = @board.point_for_pos(pos)
      dc.set_pen(@hl_pen)
      dc.draw_line(point.x+1, point.y, point.x+58, point.y)
      dc.draw_line(point.x+1, point.y+58, point.x+58, point.y+58)
      dc.draw_line(point.x+1, point.y, point.x+1, point.y+58)
      dc.draw_line(point.x+58, point.y, point.x+58, point.y+58)
    end
  end

end