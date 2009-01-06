require File.dirname(__FILE__)+"/../../lib/board.rb"

describe Rook do
  describe "#moves" do
    it "should return linear moves from sw corner" do
      board = Board.new_empty
      
      r = Rook.new(board, a1)
      moves = r.moves.map{|m| m.to}
      moves.size.should == 14
      ([a2, a3, a4, a5, a6, a7, a8,
        b1, c1, d1, e1, f1, g1, h1] | moves).size.should == 14
    end
    
    it "should return linear moves from center square" do
      board = Board.new_empty
      
      r = Rook.new(board, e5)
      moves = r.moves.map{|m| m.to}
      moves.size.should == 14
      ([d5, c5, b5, a5, f5, g5, h5,
        e4, e3, e2, e1, e6, e7, e8] | moves).size.should == 14
    end

  end
end
