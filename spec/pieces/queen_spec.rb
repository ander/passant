require File.dirname(__FILE__)+"/../../lib/board.rb"

describe Passant::Queen do
  describe "#moves" do
    it "should return all moves in center squares" do
      board = Passant::Board.new_empty
      
      q = Passant::Queen.new(board, e5)
      moves = q.moves.map{|m| m.to}
      moves.size.should == 27
      ([d4, c3, b2, a1, f6, g7, h8,
        d6, c7, b8, f4, g3, h2,
        d5, c5, b5, a5, f5, g5, h5,
        e4, e3, e2, e1, e6, e7, e8] | moves).size.should == 27
    end
  end
end
