require 'passant/board'

describe Passant::EnPassant do
  it "should move pieces correctly" do
    # black's move
    
    board = Passant::Board.new(
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
    
    after_black_move  = Passant::Board.new(
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
    mv.should be_kind_of(Passant::EnPassant)
    mv.apply
    expected  = Passant::Board.new(
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

  it "should move pieces correctly, part 2" do
    # black's move
    
    board = Passant::Board.new(
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
    
    after_black_move  = Passant::Board.new(
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
    mv.should be_kind_of(Passant::EnPassant)
    mv.apply
    expected  = Passant::Board.new(
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
