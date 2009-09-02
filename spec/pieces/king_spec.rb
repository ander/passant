require 'passant/board'

describe Passant::King do
  describe "#moves" do
    it "should return all moves in center squares" do
      board = Passant::Board.new_empty
      
      k = Passant::King.new(board, e5)
      moves = k.moves.map{|m| m.to}
      moves.size.should == 8
      ([f6, f5, f4, e6, d6, d5, d4, e6] | moves).size.should == 8
    end
  end
end
