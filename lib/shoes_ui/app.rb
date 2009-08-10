# The main Shoes (http://shoooes.net/) app

require File.dirname(__FILE__)+"/board"


Shoes.app(:title  => 'Passant', 
          :width  => ShoesUI::Board.default_size[0] + 20,
          :height => ShoesUI::Board.default_size[1] + 60,
          :resizable => false) do
  background black
  
  stack :margin => 10 do
    @board = ShoesUI::Board.new(self)
    @status = para "Welcome to Passant.", :stroke => white, :margin => 10
  end
  
end
