require File.dirname(__FILE__)+"/../../lib/board.rb"

describe Passant::Knight do
  describe "#moves" do
    it "should return all moves in center squares" do
      board = Passant::Board.new_empty
      
      k = Passant::Knight.new(board, e5)
      moves = k.moves.map{|m| m.to}
      moves.size.should == 8
      ([f7, g6, g4, f3, d3, c4, c6, d7] | moves).size.should == 8
    end
  end
end
