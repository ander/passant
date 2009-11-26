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
    
    it "should parse moves correctly (9)" do
      b = Passant::GameBoard.new
      b.move('e4')
      b.move('d5')
      b.move('d4')
      b.move('c6')
      b.move('exd5')
      b.move('a6')
      # two white pawns in the same column, only the other one can capture
      b.should == Passant::Board.new([ 'rnbqkbnr',
                                       '.p..pppp',
                                       'p.p.....',
                                       '...P....',
                                       '...P....',
                                       '........',
                                       'PPP..PPP',
                                       'RNBQKBNR' ])
      b.move('dxc6')
    end

    it "should parse moves correctly (10)" do
      b = Passant::GameBoard.new
      b.move('d3');  b.move('d6')
      b.move('Nf3'); b.move('b6')
      b.move('Nd4'); b.move('Bb7')
      b.move('Nd2'); b.move('Bf3')
      
      # two knights in the same column can capture bishop
      b.should == Passant::Board.new(['rn.qkbnr',
                                      'p.p.pppp',
                                      '.p.p....',
                                      '........',
                                      '...N....',
                                      '...P.b..',
                                      'PPPNPPPP',
                                      'R.BQKB.R' ])
      b.move('N2xf3')
    end

    it "should parse moves correctly (11)" do
      # from kasparov - fedorowicz WchT U26 Graz 1981
      # testing the parsing of promotion (h8=Q+)
      moves = %w(d4 Nf6 c4 e6 Nf3 b6 a3 c5 d5 Ba6 Qc2 exd5 cxd5 g6 Nc3 Bg7 
                 g3 O-O Bg2 d6 O-O Re8 Re1 Qc7 Bf4 Nh5 Bd2 Nd7 Qa4 Bb7
                 Qh4 a6 Rac1 b5 b4 Qd8 Bg5 f6 Bd2 f5 Bg5 Qb6 e4 cxb4
                 axb4 Rac8 Be3 Qd8 Bg5 Qb6 exf5 Rxe1+ Rxe1 Bxc3 Re7 Rc4
                 Qh3 Bc8 fxg6 Ndf6 Bxf6 Nxf6 gxh7+ Kf8 h8=Q+)
      
      b = Passant::GameBoard.new
      moves.each{|mv| b.move(mv)}

      b.should == Passant::Board.new(['..b..k.Q',
                                      '....R...',
                                      'pq.p.n..',
                                      '.p.P....',
                                      '.Pr.....',
                                      '..b..NPQ',
                                      '.....PBP',
                                      '......K.' ])
    end

  end
  
end
