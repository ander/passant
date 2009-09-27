require 'passant/ui/board_panel'
require 'passant/ui/control_panel'

module Passant::UI
  
  class InfoFrame < Wx::Frame
    def initialize(parent)
      super(parent, 
            :title => "Info",
            :pos => [parent.position.x + parent.size.x,
                     parent.position.y],
            :size => [300, 200])
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      tag_pairs = parent.board.tag_pairs
      
      @grid = Wx::Grid.new(self)
      @grid.create_grid(tag_pairs.size,1)
      @grid.col_label_size = 0
      @grid.set_col_size(0, 150)
      @grid.enable_drag_grid_size(false)
      @grid.enable_drag_row_size(false)
      
      tag_pairs.each_with_index do |t,i| 
        @grid.set_row_label_value(i, t.key)
        @grid.set_cell_value(i, 0, t.value)
      end
      
      sizer.add(@grid, 1, Wx::GROW)
      set_sizer(sizer)
      show
    end

  end
  
end
