
require File.dirname(__FILE__)+"/../board"
require File.dirname(__FILE__)+"/piece_extensions"

module ShoesUI
  class Board
    DefaultSquareSize = 60
    def self.default_size; [(DefaultSquareSize * 8)+2]*2 end
    
    attr_accessor :square_size
    
    def initialize(app)
      @app = app
      @board = ::Board.new
      @square_size = DefaultSquareSize
      draw
    end
    
    def size; [(square_size*8)+2]*2 end

    def draw
      @app.stack :width => size[0], :height => size[1] do
        draw_squares
        @board.pieces.each {|piece| piece.draw(self, @app)}
      end
    end

    def square_top(x,y); (7-y)*square_size end
    def square_left(x,y); x*square_size end

    def is_white_square?(x,y); (x+y+1) % 2 == 0 end 
    
    private
    
    def draw_squares
      @app.stroke @app.saddlebrown
      
      8.times do |x|
        8.times do |y|
          @app.fill (is_white_square?(x,y) ? @app.white : @app.black)
          @app.rect :width => square_size, :height => square_size,
                    :top => square_top(x,y), :left => square_left(x,y)
        end
      end
    end

  end
end
