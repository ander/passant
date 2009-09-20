require 'passant/ui/board_panel'
require 'passant/ui/control_panel'

module Passant::UI
  
  class MainFrame < Wx::Frame
    
    def initialize
      super(nil, 
            :title => "Passant", 
            :pos => [150, 25], 
            :size => [480, 530],
            :style => Wx::MINIMIZE_BOX|Wx::MAXIMIZE_BOX|Wx::SYSTEM_MENU|\
                      Wx::CAPTION|Wx::CLOSE_BOX|Wx::CLIP_CHILDREN)
      
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      board_panel = BoardPanel.new(self)
      control_panel = ControlPanel.new(self, board_panel)
      @status_bar = Wx::StatusBar.new(self)
      [board_panel, control_panel, @status_bar].each{|item| sizer.add(item)}
      
      set_sizer(sizer)
      show
      set_status("Welcome.")
    end
    
    def set_status(str)
      @status_bar.set_status_text(str)
    end
    
  end
  
end
