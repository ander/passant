=begin rdoc

Basic chess board.

=end

require File.dirname(__FILE__)+"/squares"
require File.dirname(__FILE__)+"/piece"
Dir.glob(File.dirname(__FILE__)+"/pieces/*.rb").each {|p| require p}
require File.dirname(__FILE__)+"/rules_engine"

class Board
  PieceLetterMap = { Pawn   => ['P','p'],
                     Rook   => ['R','r'],
                     Knight => ['N','n'],
                     Bishop => ['B','b'],
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
  
  attr_reader :pieces, :rules, :history

  def initialize(position=InitialPosition)
    @x_max = 7 
    @y_max = 7
    @rules = RulesEngine.new(self)
    set position
  end

  def self.new_empty
    Board.new(['.'*8]*8)
  end

  def add_piece(piece)
    @pieces << piece
  end
  
  def remove_piece(piece)
    @pieces -= [piece]
  end

  def off_limits?(position)
    return true if position[0] > @x_max or position[0] < 0
    return true if position[1] > @y_max or position[1] < 0
    return false
  end
  
  def square_content(pos)
    @pieces.detect{|p| p.position == pos}
  end
  alias_method :at, :square_content

  def king(color)
    @pieces.detect{|p| p.class == King and p.color == color}
  end

  # resets the board, setting pieces to initial position
  def reset
    set InitialPosition
  end
  
  def set(board_data)
    board_data = board_data.split if board_data.is_a?(String)
    @pieces = []
    @history = []
    board_data.reverse.each_with_index do |row, y|
      x = 0
      row.each_char do |letter|
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
  
  def to_s; to_a.reverse.join("\n"); end

  def all_moves(color, recurse=true)
    mvs = []
    @pieces.select{|p| p.color == color}.each do |p|
      mvs << p.moves(recurse)
    end
    mvs.flatten
  end

  def after_move(move)
    raise "Invalid piece!" unless @pieces.include?(move.piece)
    new_board = Board.new(self.to_a.reverse)
    new_move = move.class.new(new_board.at(move.from), move.to)
    new_move.apply
    new_board
  end
  
  def letter_for_piece(piece)
    pl = PieceLetterMap.detect{|k,v| piece.class == k}
    piece.color == :white ? pl[1][0] : pl[1][1]
  end
  
  def ==(other)
    self.to_s == other.to_s
  end

  private
  
  def new_piece_by_letter(letter, pos)
    pl = PieceLetterMap.detect{|k,v| v.include?(letter)}
    raise "Invalid letter: #{letter}" unless pl
    klass = pl[0]
    color = (letter == pl[1][0] ? :white : :black)
    klass.new(self, pos, color)
  end

end
