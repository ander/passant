require File.dirname(__FILE__)+"/../../lib/board.rb"

describe Pawn do
  before(:each) do
    @board = Board.new_empty
  end
  
  describe "#moves" do
    it "should return one step forward" do
      p = Pawn.new(@board, a2)
      p.moves.map{|m| m.to}.should include(a3)
    end

    it "should return two steps forward if not moved before" do
      p = Pawn.new(@board, a2)
      p.should_receive(:moved?).once.and_return(false)
      p.moves.map{|m| m.to}.should include(a4)
    end
    
    it "should not return two steps forward if moved before" do
      p = Pawn.new(@board, a2)
      p.should_receive(:moved?).once.and_return(true)
      p.moves.map{|m| m.to}.should_not include(a4)
    end    
  end
end
