require 'passant/ui/board_panel'
require 'passant/ui/control_panel'
require 'passant/ui/common'

module Passant::UI
  
  class MainFrame < Wx::Frame
    def initialize
      super(nil, 
            :title => "Passant", 
            :pos => [150, 25], 
            :size => [480, 550],
            :style => Wx::MINIMIZE_BOX|Wx::MAXIMIZE_BOX|Wx::SYSTEM_MENU|\
                      Wx::CAPTION|Wx::CLOSE_BOX|Wx::CLIP_CHILDREN)
      
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      board_panel = BoardPanel.new(self)
      control_panel = ControlPanel.new(self, board_panel)
      @status_bar = Wx::StatusBar.new(self)
      @gauge = Wx::Gauge.new(self,
                             :size => [480,20],
                             :range => 10)
      
      [board_panel, @gauge, control_panel, @status_bar].each do |item| 
        sizer.add(item)
      end
      
      set_sizer(sizer)
      
      show
      set_status("Welcome.")
    end
    
    def set_status(str)
      @status_bar.set_status_text(str)
    end

    def pulse
      @gauge.pulse
      Wx::get_app.yield
    end

    def ready
      @gauge.set_value(0)
    end

  end
  
end
