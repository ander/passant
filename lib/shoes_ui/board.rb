
require File.dirname(__FILE__)+"/../board"
require File.dirname(__FILE__)+"/piece_extensions"

module ShoesUI
  class Board
    DefaultSquareSize = 60
    def self.default_size; [(DefaultSquareSize * 8)+2]*2 end
    
    attr_accessor :square_size
    
    def initialize(app, offset)
      @app = app
      @offset = offset
      @board = ::Board.new
      @square_size = DefaultSquareSize
      draw
      
      @app.click do |button, left, top|
        click_square(get_square(left,top)) if button == 1
      end
      
      @app.release do |button, left, top|
        release_square(get_square(left,top)) if button == 1
      end

      @app.motion do |left, top|
        if @selected_piece
          @selected_piece.draw(self, @app, 
                [left - (@square_size / 2) - @selected_piece.pos_adj[0],
                 top  - (@square_size / 2) - @selected_piece.pos_adj[1]])
        end
      end
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
    
    def get_square(left,top)
      x = (left - @offset[0]) / @square_size
      y = 7 - ((top - @offset[0]) / @square_size)
      return nil if x < 0 or y < 0
      [x,y]
    end
    
    private

    def click_square(pos)
      return if pos.nil?
      @app.debug "Square #{pos.inspect} clicked"
      @selected_piece = @board.at(pos)
    end
    
    def release_square(pos)
      return if pos.nil?
      @app.debug "Square #{pos.inspect} released"
      
      if @selected_piece
        move = @selected_piece.moves.detect{|mv| mv.to == pos}
        
        if move
          move.apply 
          move.participants.each {|p| p.draw(self, @app) }
        else
          @selected_piece.draw(self, @app)
        end
        
        @selected_piece = nil
      end
    end

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
