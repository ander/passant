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
    
    castling = Castling.new(board.king(:white), g1)
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

    castling = Castling.new(board.king(:white), c1)
    board.after_move(castling).should == expected
  end

  describe "#take_back" do
    it "should undo castling (1)" do
      setting = [ '........',
                  '........',
                  '........',
                  '........',
                  '..BPPB..',
                  '.....N..',
                  'PPPQ.PPP',
                  'RN..K..R'  ]

      board = Board.new(setting)
    
      expected = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..BPPB..',
                '.....N..',
                'PPPQ.PPP',
                'RN...RK.'  ])

      castling = Castling.new(board.king(:white), g1)
      castling.apply
      board.should == expected
      castling.take_back
      board.should == Board.new(setting)
    end

    it "should undo castling (2)" do
      setting = [ '........',
                  '........',
                  '........',
                  '........',
                  '...P.B..',
                  '..N.....',
                  'PPPQPPPP',
                  'R...KBNR'  ]
      board = Board.new(setting)
      expected = Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '...P.B..',
                '..N.....',
                'PPPQPPPP',
                '..KR.BNR'  ])

      castling = Castling.new(board.king(:white), c1)
      castling.apply
      board.should == expected
      castling.take_back
      board.should == Board.new(setting)
    end
  end

end
