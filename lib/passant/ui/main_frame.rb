require 'passant/ui/board_decorator'
require 'passant/ui/control_panel'
require 'passant/ui/info_frame'
require 'passant/ui/open_pgn_frame'

module Passant::UI
  
  class MainFrame < Wx::Frame
    attr_accessor :board
    
    def initialize
      super(nil, 
            :title => "Passant", 
            :pos => [150, 25], 
            :size => [480, 575],
            :style => Wx::MINIMIZE_BOX|Wx::MAXIMIZE_BOX|Wx::SYSTEM_MENU|\
                      Wx::CAPTION|Wx::CLOSE_BOX|Wx::CLIP_CHILDREN)
      
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      @board = Passant::GameBoard.new.extend(BoardDecorator)
      @board.create_ui(self)
      control_panel = ControlPanel.new(self)
      self.status_bar = Wx::StatusBar.new(self)

      @gauge = Wx::Gauge.new(self,
                             :size => [480,20],
                             :range => 10)
      sub_sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      @value_text = Wx::StaticText.new(self, :label => @board.value_str)
      sub_sizer.add(control_panel)
      sub_sizer.add_spacer(20)
      sub_sizer.add(@value_text)
      
      [@board.panel, @gauge, sub_sizer].each do |item| 
        sizer.add(item)
      end
      
      set_sizer(sizer)
      
      self.menu_bar = Wx::MenuBar.new
      
      file_menu = Wx::Menu.new
      file_menu.append(Wx::ID_OPEN, '&Open PGN', 'Open a PGN file')
      file_menu.append(Wx::ID_SAVE, '&Save PGN', 'Save as PGN file')
      file_menu.append(Wx::ID_ABOUT, 'About', 'About Passant')
      file_menu.append(Wx::ID_EXIT, '&Quit', 'Quit Passant')

      board_menu = Wx::Menu.new
      flip_item = board_menu.append('Flip', 'Flip board.')
      info_item = board_menu.append('Info', 'Display board info.')
      reset_board_item = board_menu.append('Reset', 'Reset board.')
      
      evt_menu Wx::ID_OPEN, :open_pgn
      evt_menu Wx::ID_SAVE, :not_implemented
      evt_menu Wx::ID_ABOUT, :about
      evt_menu(Wx::ID_EXIT) { self.destroy }
      evt_menu flip_item, :flip_board
      evt_menu info_item, :show_info_frame
      evt_menu reset_board_item, :reset_board
      
      evt_window_destroy do |event|
        Passant::RulesEngine.instance.data_store.close
        event.skip
      end

      self.menu_bar.append(file_menu,  'File')
      self.menu_bar.append(board_menu, 'Board')
      
      show
      set_status("Welcome.")
    end

    def set_status(str)
      self.status_bar.set_status_text(str)
      @value_text.set_label board.value_str
      set_info
    end

    def set_info(*args)
      @info_frame.set_info(*args) if @info_frame
    end

    def pulse
      @gauge.pulse
      @board.draw_pending
      Wx::get_app.yield(true)
    end

    def ready
      @board.draw_pending
      @gauge.set_value(0)
    end

    def reset_board
      board.reset
      @board.paint
      set_info(board.tag_pairs)
      set_status('Board reset.')
    end
    
    private

    def about
      d = Wx::MessageDialog.new(self,  
        "Passant, a small chesslib.\n\n"+ 
        "Copyright 2008-2009 Antti Hakala \n"+
        "(antti.hakala@gmail.com)\n\n"+
        "Released under BSD-licence.", "About", Wx::OK)
      d.show_modal
    end
    
    def not_implemented
      d = Wx::MessageDialog.new(self,  'Not implemented.', "Not Implemented", 
                                Wx::OK)
      d.show_modal
    end

    def flip_board
      @board.flip
    end

    def show_info_frame
      @info_frame ||= InfoFrame.new(self)
      @info_frame.show
    end

    def open_pgn
      @game_select_frame ||= OpenPGNFrame.new(self)
      @game_select_frame.show
    end
  end
  
end
