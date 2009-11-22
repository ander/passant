
module Passant::UI

  class Highlighter
    attr_accessor :highlight_last_move, :mark_pawns
    
    def initialize(board_panel)
      @board_panel = board_panel
      @highlight_last_move = true
      @mark_pawns = false
      @hl_pen = Wx::Pen.new(Wx::RED, 3)
    end
    
    def highlight(dc)
      if @highlight_last_move and mv = @board_panel.board.last_move
        square_hl(dc, mv.from)
        square_hl(dc, mv.to)
      end
    end
    
    private
    
    def square_hl(dc, pos)
      point = @board_panel.point_for_pos(pos)
      dc.set_pen(@hl_pen)
      dc.draw_line(point.x+1, point.y, point.x+58, point.y)
      dc.draw_line(point.x+1, point.y+58, point.x+58, point.y+58)
      dc.draw_line(point.x+1, point.y, point.x+1, point.y+58)
      dc.draw_line(point.x+58, point.y, point.x+58, point.y+58)
    end
  end

end