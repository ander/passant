# UI extensions for Piece

class Piece
  
  def draw(ui_board, app, ui_pos=ui_position(ui_board))
    if !self.board.pieces.include?(self)
      @image.hide if @image
    elsif @image
      @image.move ui_pos[0] + pos_adj[0], ui_pos[1] + pos_adj[1]
    else
      path = image_file_path
      return unless File.exists?(path)
      ui_board.container.append do
        @image = app.image path, :left => ui_pos[0] + pos_adj[0], 
                                 :top => ui_pos[1] + pos_adj[1]
      end
    end
  end

  def pos_adj; [10, 5] end
  
  alias_method :capture_without_ui, :capture
  def capture
    capture_without_ui
    @image.hide if @image
  end

  alias_method :uncapture_without_ui, :uncapture
  def uncapture
    uncapture_without_ui
    @image.show if @image
  end
  
  private

  def ui_position(ui_board)
    [ui_board.square_left(self.x, self.y),
     ui_board.square_top(self.x, self.y)]
  end

  def image_file_path
    File.expand_path File.join(File.dirname(__FILE__), 'images', 
                     "#{self.color}_#{self.class}.png".downcase)
  end
end
