
module Passant::UI
  
  module BoardUIDecorator
    def ui=(ui)
      @ui = ui
      pieces.each{|p| p.initialize_ui(@ui)}
    end
    
    def ui; @ui end

    def add_piece(piece)
      super(piece)
      piece.initialize_ui(@ui) if @ui
    end

    def move_abs(from, to)
      mv = super(from, to)
      @ui.pending << lambda{ mv.draw }
      mv
    end
    
    def move(move_str)
      mv = super(move_str)
      @ui.pending << lambda{ mv.draw }
      mv
    end
  end
  
end