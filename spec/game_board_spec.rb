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
      lambda { b.move(a7,a6) }.should raise_error(Passant::Board::Exception)
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
                                                  "1-0")
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
                                                  "1/2-1/2")
    end

    it "should parse moves correctly (1)" do
      b = Passant::GameBoard.new
      b.move('e4')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'pppppppp',
                                       '........',
                                       '........',
                                       '....P...',
                                       '........',
                                       'PPPP.PPP',
                                       'RNBQKBNR'  ])
      b.move('c5')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'pp.ppppp',
                                       '........',
                                       '..p.....',
                                       '....P...',
                                       '........',
                                       'PPPP.PPP',
                                       'RNBQKBNR'  ])
    end

    it "should parse moves correctly (2)" do
      b = Passant::GameBoard.new
      b.move('e4')
      b.move('c5')
      b.move('Bc4')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'pp.ppppp',
                                       '........',
                                       '..p.....',
                                       '..B.P...',
                                       '........',
                                       'PPPP.PPP',
                                       'RNBQK.NR'  ])
    end

    it "should parse moves correctly (3)" do
      b = Passant::GameBoard.new
      b.move('e4')
      b.move('d5')
      b.move('exd5')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'ppp.pppp',
                                       '........',
                                       '...P....',
                                       '........',
                                       '........',
                                       'PPPP.PPP',
                                       'RNBQKBNR'  ])
    end

    it "should parse moves correctly (4)" do
      b = Passant::GameBoard.new
      b.move('d2d4')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'pppppppp',
                                       '........',
                                       '........',
                                       '...P....',
                                       '........',
                                       'PPP.PPPP',
                                       'RNBQKBNR'  ])
    end
    
    it "should parse moves correctly (5)" do
      b = Passant::GameBoard.new
      b.move('d2d4')
      b.move('d7d5')
      b.move('Bcf4')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'ppp.pppp',
                                       '........',
                                       '...p....',
                                       '...P.B..',
                                       '........',
                                       'PPP.PPPP',
                                       'RN.QKBNR'  ])
    end
    
    it "should parse moves correctly (6)" do
      b = Passant::GameBoard.new
      b.move('d2d4')
      b.move('g7g5')
      b.move('Bcxg5')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'pppppp.p',
                                       '........',
                                       '......B.',
                                       '...P....',
                                       '........',
                                       'PPP.PPPP',
                                       'RN.QKBNR'  ])
    end

    it "should parse moves correctly (7)" do
      b = Passant::GameBoard.new
      b.move('Nf3')
      b.move('e7e5')
      b.move('Nf3xe5')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       'pppp.ppp',
                                       '........',
                                       '....N...',
                                       '........',
                                       '........',
                                       'PPPPPPPP',
                                       'RNBQKB.R'  ])
    end

    it "should parse moves correctly (8)" do
      b = Passant::GameBoard.new
      b.move('e4')
      b.move('a6')
      b.move('e5')
      b.move('d5')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       '.pp.pppp',
                                       'p.......',
                                       '...pP...',
                                       '........',
                                       '........',
                                       'PPPP.PPP',
                                       'RNBQKBNR' ])
      b.move('exd5')
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       '.pp.pppp',
                                       'p..P....',
                                       '........',
                                       '........',
                                       '........',
                                       'PPPP.PPP',
                                       'RNBQKBNR' ])
    end

  end
  
end
