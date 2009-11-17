require 'forwardable'
require 'passant/logging'
require 'passant/squares'
require 'passant/piece'
require 'passant/pieces/bishop'
require 'passant/pieces/king'
require 'passant/pieces/knight'
require 'passant/pieces/pawn'
require 'passant/pieces/queen'
require 'passant/pieces/rook'
require 'passant/rules_engine'
require 'passant/evaluators/standard_evaluator'
require 'passant/evaluators/berliner_evaluator'
require 'passant/evaluators/composite_evaluator'

module Passant

  # Basic chess board.
  class Board
    extend Forwardable
    class Exception < StandardError; end
    
    PieceLetterMap = { Pawn   => ['P','p'],
                       Knight => ['N','n'],
                       Bishop => ['B','b'],
                       Rook   => ['R','r'],
                       Queen  => ['Q','q'],
                       King   => ['K','k'] }
    
    # White's left rook is origo (0,0)
    InitialPosition = [ 'rnbqkbnr',
                        'pppppppp',
                        '........',
                        '........',
                        '........',
                        '........',
                        'PPPPPPPP',
                        'RNBQKBNR'  ]
  
    # delegate rule methods to RulesEngine passing self as first argument
    def self.delegate_to_rules(*meths)
      meths.each do |meth|
        class_eval %Q(def #{meth}(*args)
                        @rules.send('#{meth}', *([self]+args))
                      end)
      end
    end
    
    attr_reader :pieces, :rules, :takebacks
    
    attr_accessor :evaluator
    
    delegate_to_rules :valid_move?, :valid_linear_move?, :en_passant,
                      :castlings, :check?, :checkmate?, :draw?
    
    def_delegators :@evaluator, :value, :value_str
    
    def initialize(position=InitialPosition)
      @rules = RulesEngine.instance
      @takebacks = []
      @evaluator = CompositeEvaluator.new(self, StandardEvaluator, 
                                          BerlinerEvaluator)
      set position
    end

    def self.new_empty
      Board.new(['.'*8]*8)
    end
    
    # The method to call to move a piece.
    # move parsing needs a color if 'to' is not provided,
    # so we have to guess the turn belongs to opponent of last move or white.
    # (Board is not turn based, see GameBoard)
    def move(from, to=nil)
      color = last_move.nil? ? :white : opponent(last_move.piece.color)
      Move.parse(self, color, from, to).apply
    end
    
    def add_piece(piece)
      @pieces << piece
    end
  
    def remove_piece(piece)
      @pieces.delete(piece)
    end

    def off_limits?(position)
      position[0] > 7 or position[0] < 0 or \
      position[1] > 7 or position[1] < 0
    end
  
    def at(pos)
      @pieces.detect{|p| p.position == pos}
    end
  
    def king(color)
      @pieces.detect{|p| p.class == King and p.color == color}
    end

    # resets the board, setting pieces to initial position
    def reset
      set InitialPosition
    end

    def add_history(mv)
      @history << mv
      @string_rep = nil
    end
    
    def remove_history(mv)
      @history.delete(mv)
      @string_rep = nil
    end
    
    def last_move
      @history.last
    end
    
    def set(board_data)
      @pieces = []
      @history = []
      board_data = board_data.split if board_data.is_a?(String)
    
      board_data.reverse.each_with_index do |row, y|
        x = 0
        row.size.times do |i|
          letter = row[i,1]
          new_piece_by_letter(letter, [x,y]) if letter != '.'
          x += 1
        end
      end
    end

    def to_a
      rep = ['........', '........', '........', '........',
             '........', '........', '........', '........']
      @pieces.each do |p|
        letter = letter_for_piece(p)
        rep[p.position[1]][p.position[0]] = letter
      end
      rep
    end
    
    # used extensively
    def to_s
      @string_rep ||= to_a.reverse.join("\n")
    end
    
    def all_moves(color, recurse=true, include_castlings=true)
      mvs = []
      @pieces.select{|p| p.color == color}.each do |p|
        if !include_castlings and p.class == King
          mvs << p.moves(recurse, false)
        else
          mvs << p.moves(recurse)
        end
      end
      mvs.flatten
    end

    def after_move(move)
      raise Board::Exception.new("Invalid piece!") unless @pieces.include?(move.piece)
      new_board = Board.new(self.to_a.reverse)
      new_move = move.class.new(new_board.at(move.from), move.to)
      new_move.apply
      new_board
    end
  
    def letter_for_piece(piece)
      pl = PieceLetterMap.detect{|k,v| piece.class == k}
      piece.color == :white ? pl[1][0] : pl[1][1]
    end
  
    def letter_for_piece_class_and_color(klass, color)
      pl = PieceLetterMap.detect{|k,v| klass == k}
      color == :white ? pl[1][0] : pl[1][1]
    end
  
    def take_back
      last_mv = last_move
      last_mv.take_back if last_mv
    end
    
    def undo_takeback
      tb = @takebacks.last
      tb.apply if tb
    end

    # N.B. does not take history into account
    def ==(other)
      self.to_s == other.to_s
    end
  
    def inspect; "\n"+self.to_s; end

    private

    def opponent(color)
      color = (color == :white ? :black : :white)
    end

    def new_piece_by_letter(letter, pos)
      pl = PieceLetterMap.detect{|k,v| v.include?(letter)}
      raise "Invalid letter: #{letter}" unless pl
      klass = pl[0]
      color = (letter == pl[1][0] ? :white : :black)
      klass.new(self, pos, color)
    end

  end

end # module Passant
