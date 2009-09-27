require 'passant/ui/board_panel'
require 'passant/ui/control_panel'
require 'passant/ui/info_frame'

module Passant::UI
  
  class MainFrame < Wx::Frame
    def initialize
      super(nil, 
            :title => "Passant", 
            :pos => [150, 25], 
            :size => [480, 575],
            :style => Wx::MINIMIZE_BOX|Wx::MAXIMIZE_BOX|Wx::SYSTEM_MENU|\
                      Wx::CAPTION|Wx::CLOSE_BOX|Wx::CLIP_CHILDREN)
      
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      @board_panel = BoardPanel.new(self)
      control_panel = ControlPanel.new(self)
      @status_bar = self.create_status_bar

      @gauge = Wx::Gauge.new(self,
                             :size => [480,20],
                             :range => 10)
      
      [@board_panel, @gauge, control_panel].each do |item| 
        sizer.add(item)
      end
      
      set_sizer(sizer)
      
      self.menu_bar = Wx::MenuBar.new
      
      file_menu = Wx::Menu.new
      file_menu.append(Wx::ID_OPEN, '&Open PGN', 'Open a PGN file')
      file_menu.append(Wx::ID_SAVE, '&Save PGN', 'Save as PGN file')
      
      board_menu = Wx::Menu.new
      flip_item = board_menu.append('Flip', 'Flip board.')
      info_item = board_menu.append('Info', 'Info')
      reset_board_item = board_menu.append('Reset', 'Reset board.')
      
      evt_menu Wx::ID_OPEN, :not_implemented
      evt_menu Wx::ID_SAVE, :not_implemented
      evt_menu flip_item, :flip_board
      evt_menu info_item, :show_info_frame
      evt_menu reset_board_item, :reset_board

      self.menu_bar.append(file_menu,  'File')
      self.menu_bar.append(board_menu, 'Board')

      show
      set_status("Welcome.")
    end

    def board
      @board_panel.board
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

    private

    def not_implemented
      d = Wx::MessageDialog.new(self,  'Not implemented.', "Not Implemented", 
                                Wx::OK)
      d.show_modal
    end

    def flip_board
      @board_panel.flip_board
    end

    def show_info_frame
      @info_frame = InfoFrame.new(self)
    end
    
    def reset_board
      board.reset
      @board_panel.paint_board
      set_status('Board reset.')
    end
  end
  
end
