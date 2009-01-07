require File.dirname(__FILE__)+"/../lib/board.rb"

describe EnPassant do
  it "should move pieces correctly, eat left" do
    # black's move
    
    board = Board.new(
              [ '........',
                '...p....',
                '....p...',
                '....P...',
                '........',
                '........',
                '........',
                '........'  ])
    mv = board.at(d7).moves.last
    mv.apply
    
    after_black_move  = Board.new(
              [ '........',
                '........',
                '....p...',
                '...pP...',
                '........',
                '........',
                '........',
                '........'  ])
    
    board.should == after_black_move
    board.at(e5).moves.size.should == 1
    mv = board.at(e5).moves.first
    mv.should be_kind_of(EnPassant)
    mv.apply
    expected  = Board.new(
              [ '........',
                '........',
                '...Pp...',
                '........',
                '........',
                '........',
                '........',
                '........'  ])
    board.should == expected
  end

  it "should move pieces correctly, eat right" do
    # black's move
    
    board = Board.new(
              [ '........',
                '.....p..',
                '....p...',
                '....P...',
                '........',
                '........',
                '........',
                '........'  ])
    mv = board.at(f7).moves.last
    mv.apply
    
    after_black_move  = Board.new(
              [ '........',
                '........',
                '....p...',
                '....Pp..',
                '........',
                '........',
                '........',
                '........'  ])
    
    board.should == after_black_move
    board.at(e5).moves.size.should == 1
    mv = board.at(e5).moves.first
    mv.should be_kind_of(EnPassant)
    mv.apply
    expected  = Board.new(
              [ '........',
                '........',
                '....pP..',
                '........',
                '........',
                '........',
                '........',
                '........'  ])
    board.should == expected
  end

end
