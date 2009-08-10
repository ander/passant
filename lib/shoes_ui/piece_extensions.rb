# UI extensions for Piece

class Piece

  # TODO override capture / promote etc.

  def draw(ui_board, app)
    if @image
      # move / redraw
    else
      path = image_file_path
      return unless File.exists?(path)
      @image = app.image path, 
               :left => ui_board.square_left(self.x, self.y) + 10, 
               :top => ui_board.square_top(self.x, self.y) + 5
    end
  end
  
  private
  
  def image_file_path
    File.expand_path File.join(File.dirname(__FILE__), 'images', 
                     "#{self.color}_#{self.class}.png".downcase)
  end
end
