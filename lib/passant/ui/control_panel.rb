module Passant::UI
  class ControlPanel < Wx::Panel
    def initialize(parent)
      super(parent)
      
      take_back_b = Wx::Button.new(self, Wx::ID_ANY, '<')
      undo_takeback_b = Wx::Button.new(self, Wx::ID_ANY, '>')

      sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      sizer.add(take_back_b)
      sizer.add(undo_takeback_b)
      
      set_sizer(sizer)
      
      evt_button(take_back_b)     { |event| take_back }
      evt_button(undo_takeback_b) { |event| undo_takeback }
    end

    private
    
    def take_back
      mv = parent.board.take_back
      if mv
        parent.set_status("Took back #{mv.to_pgn}.")
        mv.piece.board.refresh
      end
    end

    def undo_takeback
      mv = Wx::get_app.responsively do
        parent.board.undo_takeback
      end
      
      if mv
        parent.set_status(mv.to_pgn) 
        mv.piece.board.refresh
      end
    end
  end
end
