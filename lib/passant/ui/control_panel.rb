module Passant::UI
  class ControlPanel < Wx::Panel
    def initialize(parent, board_panel)
      super(parent)
      @board_panel = board_panel
      reset_b = Wx::Button.new(self, Wx::ID_ANY, 'Reset')
      take_back_b = Wx::Button.new(self, Wx::ID_ANY, 'Take back')

      sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      sizer.add(reset_b)
      sizer.add(take_back_b)
      set_sizer(sizer)
      
      evt_button(reset_b.id) { |event| reset_board }
      evt_button(take_back_b.id) { |event| take_back }
    end

    private

    def reset_board
      @board_panel.board.reset
      @board_panel.paint_board
      parent.set_status('Board reset.')
    end
    
    def take_back
      @board_panel.board.take_back
    end
  end
end
