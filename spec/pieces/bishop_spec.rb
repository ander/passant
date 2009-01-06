require File.dirname(__FILE__)+"/../../lib/board.rb"

describe Bishop do
  describe "#moves" do
    it "should return all moves in center squares" do
      board = Board.new_empty
      
      b = Bishop.new(board, e5)
      moves = b.moves.map{|m| m.to}
      moves.size.should == 13
      ([d4, c3, b2, a1, f6, g7, h8, d6, c7, b8, f4, g3, h2] | moves).\
        size.should == 13
    end
  end
end
