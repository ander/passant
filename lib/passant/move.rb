require 'passant/move_parser'

module Passant
  
  # Move of a piece.
  class Move
    attr_reader :piece, :from, :to
    attr_accessor :comment
    
    def initialize(piece, move_to)
      @comment = nil
      @piece = piece
      @from = piece.position
      @to = move_to
      @capture_piece = @piece.board.at(@to)
    end
    
    def apply
      @capture_piece.capture if @capture_piece
      @piece.position = @to
      @piece.history << self
      @piece.board.add_history(self)
      @piece.board.clear_takebacks_after(self)
      self
    end
  
    def take_back
      @capture_piece.uncapture if @capture_piece
      @piece.position = @from
      @piece.history.delete(self)
      @piece.board.remove_history(self)
      @piece.board.add_takeback(self)
      self
    end
    
    def to_s
      l = @piece.board.letter_for_piece(@piece)
      c = capture? ? 'x' : ''
      "#{l}#{chess_coords(@from)}#{c}#{chess_coords(@to)}"
    end
    
    def to_pgn
      if @comment and @comment.length > 0
        self.to_s + " {#{@comment}}"
      else
        self.to_s
      end
    end

    def capture?
      !@capture_piece.nil?
    end

    def participants; [@piece, @capture_piece].compact end
    
    def inspect; to_s; end
    
  end # class Move

end
