
module Passant::UI
  
  class InfoFrame < Wx::Frame
    
    class InfoGrid < Wx::Grid
      def initialize(parent, cols)
        super(parent)
        create_grid(0,cols)
        self.col_label_size = 0
        set_col_size(0, 150)
        enable_drag_grid_size(false)
        enable_drag_row_size(false)
      end
    end
    
    def initialize(parent)
      super(parent, 
            :title => "Passant: Board Info",
            :pos => [parent.position.x + parent.size.x,
                     parent.position.y],
            :size => [300, 400])
      
      @tag_pair_grid = InfoGrid.new(self,1)
      @movetext_grid = InfoGrid.new(self,2)
      set_info
      
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      sizer.add @tag_pair_grid, 0, Wx::GROW
      sizer.add_spacer(20)
      sizer.add @movetext_grid, 1, Wx::GROW
      
      set_sizer(sizer)
      
      evt_close do |close_event| 
        if close_event.can_veto
          self.hide
          close_event.veto
        else
          self.destroy
        end
      end
      
      show
    end
    
    
    def set_info(only_tag_pairs=nil)
      tag_pairs = only_tag_pairs || parent.board.tag_pairs
      @tag_pair_grid.delete_rows(0, @tag_pair_grid.get_number_rows)
      @tag_pair_grid.insert_rows(0, tag_pairs.size)
      
      tag_pairs.each_with_index do |t,i|
        @tag_pair_grid.set_row_label_value(i, t.key)
        @tag_pair_grid.set_cell_value(i, 0, t.value)
      end
      
      if !only_tag_pairs and parent.board.last_move
        rows = parent.board.movetext_array
        @movetext_grid.delete_rows(0, @movetext_grid.get_number_rows)
        @movetext_grid.insert_rows(0, rows.size)
        
        rows.each_with_index do |row,i|
          @movetext_grid.set_row_label_value(i, row[0])
          @movetext_grid.set_cell_value(i, 0, row[1] || '')
          @movetext_grid.set_cell_value(i, 1, row[2] || '')
        end
      else
        @movetext_grid.delete_rows(0, @movetext_grid.get_number_rows)
      end
      
    end

  end
  
end
