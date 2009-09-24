module Passant::UI
  class ControlPanel < Wx::Panel
    def initialize(parent, board_panel)
      super(parent)
      @board_panel = board_panel
      reset_b = Wx::Button.new(self, Wx::ID_ANY, 'Reset')
      other_b = Wx::Button.new(self, Wx::ID_ANY, '...')
      take_back_b = Wx::Button.new(self, Wx::ID_ANY, '<')
      undo_takeback_b = Wx::Button.new(self, Wx::ID_ANY, '>')

      sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      [reset_b, other_b, take_back_b, undo_takeback_b].each do |b|
        sizer.add(b)
      end
      
      set_sizer(sizer)
      
      evt_button(reset_b.id)         { |event| reset_board }
      evt_button(take_back_b.id)     { |event| take_back }
      evt_button(undo_takeback_b.id) { |event| undo_takeback }
    end

    private

    def reset_board
      @board_panel.board.reset
      @board_panel.paint_board
      parent.set_status('Board reset.')
    end
    
    def take_back
      mv = @board_panel.board.take_back
      if mv
        mv.draw
        parent.set_status("Took back #{mv}.")
      end
    end

    def undo_takeback
      mv = Wx::get_app.responsively do
        @board_panel.board.undo_takeback
      end
      
      if mv
        mv.draw
        parent.set_status(mv.to_s)
      end
    end
  end
end
