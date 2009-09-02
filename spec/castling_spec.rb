require 'passant/board'

describe Passant::Castling do
  it "should move pieces correctly, short" do
    board = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..BPPB..',
                '.....N..',
                'PPPQ.PPP',
                'RN..K..R'  ])
    
    expected = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..BPPB..',
                '.....N..',
                'PPPQ.PPP',
                'RN...RK.'  ])
    
    castling = Passant::Castling.new(board.king(:white), g1)
    board.after_move(castling).should == expected
  end

  it "should move pieces correctly, long" do
    board = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '...P.B..',
                '..N.....',
                'PPPQPPPP',
                'R...KBNR'  ])

    expected = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '...P.B..',
                '..N.....',
                'PPPQPPPP',
                '..KR.BNR'  ])

    castling = Passant::Castling.new(board.king(:white), c1)
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

      board = Passant::Board.new(setting)
    
      expected = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..BPPB..',
                '.....N..',
                'PPPQ.PPP',
                'RN...RK.'  ])

      castling = Passant::Castling.new(board.king(:white), g1)
      castling.apply
      board.should == expected
      castling.take_back
      board.should == Passant::Board.new(setting)
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
      board = Passant::Board.new(setting)
      expected = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '...P.B..',
                '..N.....',
                'PPPQPPPP',
                '..KR.BNR'  ])

      castling = Passant::Castling.new(board.king(:white), c1)
      castling.apply
      board.should == expected
      castling.take_back
      board.should == Passant::Board.new(setting)
    end
  end

end
