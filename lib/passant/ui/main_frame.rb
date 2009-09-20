
require 'passant/game_board'
require 'passant/ui/board_panel'
require 'passant/ui/extensions'
require 'passant/ui/common'

module Passant::UI
  
  class MainFrame < Wx::Frame
    
    def initialize
      super(nil, 
            :title => "Passant", 
            :pos => [150, 25], 
            :size => [480, 500],
            :style => Wx::MINIMIZE_BOX|Wx::MAXIMIZE_BOX|Wx::SYSTEM_MENU|\
                      Wx::CAPTION|Wx::CLOSE_BOX|Wx::CLIP_CHILDREN)
      
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      sizer.add(BoardPanel.new(self))
      @status_bar = Wx::StatusBar.new(self)
      sizer.add(@status_bar)
      set_sizer(sizer)
      show
      set_status("Welcome.")
    end
    
    def set_status(str)
      @status_bar.set_status_text(str)
    end
    
  end
  
end
