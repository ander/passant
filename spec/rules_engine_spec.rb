require File.dirname(__FILE__)+"/../lib/board.rb"

describe RulesEngine do
  
  describe "#valid_linear_move?" do
    it "should exclude moves which end on or jump over own pieces" do
      board = Board.new_empty
      board.set(['........', 
                 '........', 
                 '........', 
                 '........',
                 '........', 
                 '........', 
                 'PP......', 
                 'RN......'])
      rook = board.at(a1)
      mv = Move.new(rook, a2)
      board.rules.valid_linear_move?(mv).should == false
      mv2 = Move.new(rook, a3)
      board.rules.valid_linear_move?(mv2).should == false
    end
    
    it "should exclude moves which jump over enemy pieces" do
      board = Board.new_empty
      board.set(['........', 
                 '........', 
                 '........', 
                 '........',
                 '........', 
                 '........', 
                 'pP......', 
                 'RN......'])
      rook = board.at(a1)
      mv = Move.new(rook, a2)
      board.rules.valid_linear_move?(mv).should == true
      mv2 = Move.new(rook, a3)
      board.rules.valid_linear_move?(mv2).should == false
    end
  end
  
  it "should not allow moves which cause self check" do
    board = Board.new_empty
    board.set(['...r....', 
               '........', 
               '........', 
               '........',
               '........', 
               '...N....', 
               '...K....', 
               '........'])
    knight = board.at(d3)
    knight.moves.should be_empty
    board.king(:white).moves.size.should == 7
  end
  
  it "should not allow moves which ignore self check" do
    board = Board.new_empty
    board.set(['........', 
               '........', 
               '........', 
               '........',
               '........', 
               '........', 
               '.PP.....', 
               'K......r'])
    board.all_moves(:white).size.should == 1
    board.king(:white).moves.first.to.should == a2
  end
  
  it "should allow to block a check" do
    board = Board.new_empty
    board.set(['........', 
               '........', 
               '........', 
               '........',
               '........', 
               '........', 
               'PPB.....', 
               'K......r'])
    board.all_moves(:white).size.should == 2
    bishop = board.at(c2)
    (bishop.moves.map{|m| m.to} | [b1, d1]).size.should == 2
  end
  
  it "should recognize draw" do
    board = Board.new(
              ['.r......', 
               '........', 
               '........', 
               '........',
               '........', 
               '........', 
               '.......r', 
               'K.......'])
    board.rules.draw?(:white).should == true
  end

  it "should recognize checkmate" do
    board = Board.new(
              ['.r......', 
               '........', 
               'r.......', 
               '........',
               '........', 
               '........', 
               '........', 
               'K.......'])
    board.rules.checkmate?(:white).should == true
  end

  it "should allow long castling" do
    board = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '...P.B..',
                '..N.....',
                'PPPQPPPP',
                'R...KBNR'  ])
    
    c = board.rules.castlings(board.king(:white))
    c.size.should == 1
    c.first.to.should == c1
  end

  it "should allow short castling" do
    board = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..BPPB..',
                '.....N..',
                'PPPQ.PPP',
                'RN..K..R'  ])
    
    c = board.rules.castlings(board.king(:white))
    c.size.should == 1
    c.first.to.should == g1
  end
  

end
