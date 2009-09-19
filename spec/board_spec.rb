require 'passant/board'

describe Passant::Board do
  
  describe "#set" do
    it "should set pieces in place" do
      board = Passant::Board.new_empty
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
      p.class.should == Passant::Rook
      p.color.should == :white
      p.position.should == e5
    end
  end
  
  describe "#move" do
    it "should make a valid move" do
      b = Passant::Board.new
      b.move(a2,a4)
      b.at(a4).class.should == Passant::Pawn
    end
    
    it "should raise InvalidMove if nothing to move" do
      b = Passant::Board.new
      lambda { b.move(a3,a4) }.should raise_error Passant::Board::InvalidMove
    end

    it "should raise InvalidMove if invalid move for piece" do
      b = Passant::Board.new
      b.at(a2).class.should == Passant::Pawn
      lambda { b.move(a2,a5) }.should raise_error Passant::Board::InvalidMove
    end
  end

end
