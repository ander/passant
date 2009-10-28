
module Passant::UI
  
  class OpenPGNFrame < Wx::Frame
    def initialize(parent)
      super(parent, 
            :title => "Passant: Open PGN",
            :pos => [parent.position.x + parent.size.x,
                     parent.position.y],
            :size => [480, 575])
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      
      @pgn_path = Wx::StaticText.new(self, Wx::ID_ANY, 
                                     'no file selected')
      open_file_b = Wx::Button.new(self, Wx::ID_ANY, 'Open PGN File')
      @game_list = Wx::ListBox.new(self, :style => Wx::LB_SINGLE)
      @load_game_b = Wx::Button.new(self, Wx::ID_ANY, 'Load Game')
      @load_game_b.disable
      
      sizer.add(open_file_b, 0, Wx::ALIGN_CENTER)
      sizer.add_spacer(20)
      sizer.add(@pgn_path, 0, Wx::ALIGN_CENTER)
      sizer.add_spacer(10)
      sizer.add(@game_list, 1, Wx::GROW)
      sizer.add(@load_game_b, 0, Wx::ALIGN_RIGHT)

      evt_button open_file_b, :open_file
      evt_button @load_game_b, :load_game
      evt_listbox @game_list, :game_selected
      
      evt_close do |close_event| 
        if close_event.can_veto
          self.hide
          close_event.veto
        else
          self.destroy
        end
      end

      set_sizer(sizer)
      show
    end
    
    private
    
    def open_file
      dialog = Wx::FileDialog.new(self, "Choose a PGN file", '', '', 
                                  'PGN Files (*.PGN;*.pgn)|*.PGN;*.pgn')
      
      if dialog.show_modal == Wx::ID_OK and path = dialog.get_path
        @pgn_path.set_label(path)
        pgn = Passant::PGN::File.new(path)
        @games = pgn.games
        Wx::get_app.responsively { @game_list.set(@games.map{|g| g.title}) }
      end
    end
    
    def game_selected
      @load_game_b.enable
    end
    
    def load_game
      game = @games[@game_list.get_selection]
      
      Wx::get_app.responsively do
        begin
          self.disable
          parent.reset_board
          parent.set_info(game.tag_pairs)
          game.to_board(parent.board)
          
        rescue  Passant::Move::Invalid, Passant::Board::Exception,\
               Passant::GameBoard::GameOver => e
          parent.set_status(e.message)
        
        ensure
          self.enable
        end
      end
    end

  end
  
end
