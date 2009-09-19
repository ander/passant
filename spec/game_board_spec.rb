require 'passant/game_board'

describe Passant::GameBoard do
  
  it "should set turn to :white on initialize" do
    b = Passant::GameBoard.new
    b.turn.should == :white
  end

  describe "#move" do
    it "should alternate the turn color" do
      b = Passant::GameBoard.new
      b.move(a2,a4)
      b.turn.should == :black
      b.move(a7,a5)
      b.turn.should == :white
    end
    
    it "should raise InvalidMove if moving on wrong turn" do
      b = Passant::GameBoard.new
      b.at(a7).color.should == :black
      lambda { b.move(a7,a6) }.should raise_error(Passant::Board::InvalidMove)
    end

    it "should raise GameOver when game checkmated" do
      b = Passant::GameBoard.new
      b.set(['k.......', 
             '........', 
             '........', 
             '........',
             '........', 
             '........', 
             '..R.....', 
             '.R......'], :white)
      lambda { b.move(c2, a2)}.should raise_error(Passant::GameBoard::GameOver,
                                                  "Checkmate (white wins)")
    end
    
    it "should raise GameOver when game drawn" do
      b = Passant::GameBoard.new
      b.set(['k.......', 
             '........', 
             '........', 
             '........',
             '........', 
             '........', 
             '..R.....', 
             '.R......'], :white)
      lambda { b.move(c2, c7)}.should raise_error(Passant::GameBoard::GameOver,
                                                  "Draw")
    end

  end
  
end
