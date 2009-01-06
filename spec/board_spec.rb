require File.dirname(__FILE__)+"/../lib/board.rb"

describe Board do
  
  describe "#set" do
    it "should set pieces in place" do
      board = Board.new_empty
      board.pieces.size.should == 0
      board.set(['........', 
                 '........', 
                 '........', 
                 '....R...',
                 '........', 
                 '........', 
                 '........', 
                 '........'])
      board.pieces.size.should == 1
      p = board.pieces.first
      p.class.should == Rook
      p.color.should == :white
      p.position.should == e5
    end
  end
  
end
