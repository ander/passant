require File.dirname(__FILE__)+"/../lib/board.rb"

describe Castling do
  it "should move pieces correctly, short" do
    board = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..BPPB..',
                '.....N..',
                'PPPQ.PPP',
                'RN..K..R'  ])
    
    expected = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..BPPB..',
                '.....N..',
                'PPPQ.PPP',
                'RN...RK.'  ])
    
    castling = board.rules.castlings(board.king(:white)).first
    board.after_move(castling).should == expected
  end

  it "should move pieces correctly, long" do
    board = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '...P.B..',
                '..N.....',
                'PPPQPPPP',
                'R...KBNR'  ])

    expected = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '...P.B..',
                '..N.....',
                'PPPQPPPP',
                '..KR.BNR'  ])

    castling = board.rules.castlings(board.king(:white)).first
    board.after_move(castling).should == expected
  end

end
