=begin rdoc

Base class for chess pieces.

=end

require 'passant/move'
require 'passant/castling'
require 'passant/en_passant'
require 'passant/promotion'

module Passant

  class Piece
    attr_accessor :position, :history
    attr_reader :board, :color
  
    def initialize(board, position, color=:white)
      @board = board
      @position = position
      @color = color
      @history = []
      @board.add_piece(self)
    end
    
    def x; @position[0]; end
    def y; @position[1]; end
    
    def moves(recurse=true)
      raise "Define moves by overriding #moves (#{self.class})!"
    end
    
    # return true if this piece has been moved
    def moved?; !@history.empty?; end

    def self.advance_direction(color)
      color == :white ? 1 : -1
    end

    def advance_direction
      self.class.advance_direction(color)
    end
    
    def white?; color == :white; end
    def black?; color == :black; end
    
    def enemy_color
      color == :white ? :black : :white
    end
    
    def enemy?(piece)
      return false unless piece
      piece.color == enemy_color
    end
    
    def linear_moves(dirs, can_capture=true, recurse=true)
      mvs = []
      dirs.each do |dir|
        mv = Move.new(self, [@position[0]+dir[0], @position[1]+dir[1]])
        while !@board.off_limits?(mv.to)
          mvs << mv if @board.rules.valid_linear_move?(mv, can_capture, recurse)
          break unless @board.at(mv.to).nil?
          mv = Move.new(self, [mv.to[0]+dir[0], mv.to[1]+dir[1]])
        end
      end
      mvs
    end
    
    def capture; @board.remove_piece(self); end
    def uncapture
      @board.add_piece(self) unless @board.pieces.include?(self)
    end
    def active?
      @board.pieces.include?(self)
    end
  end

end
