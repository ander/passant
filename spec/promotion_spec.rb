require 'passant/board'

describe Passant::Promotion do
  it "should promote a pawn" do    
    board = Passant::Board.new(
              [ '........',
                'P.......',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........'  ])

    mv = Passant::Promotion.new(board.at(a7), a8)
    mv.apply
    
    after_promo = Passant::Board.new(
              [ 'Q.......',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........'  ])
    
    board.should == after_promo
    board.pieces.size.should == 1
  end

  it "should do a capturing promotion" do
    board = Passant::Board.new(
              [ '.n......',
                'P.......',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........'  ])

    mv = Passant::Promotion.new(board.at(a7), b8)
    mv.apply
    
    after_promo = Passant::Board.new(
              [ '.Q......',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........'  ])
    
    board.should == after_promo
    board.pieces.size.should == 1
  end


  describe "#take_back" do
    it "should undo promotion" do     
      setting = [ '........',
                  'P.......',
                  '........',
                  '........',
                  '........',
                  '........',
                  '........',
                  '........'  ]
      
      board = Passant::Board.new(setting)
      
      mv = Passant::Promotion.new(board.at(a7), a8)
      mv.apply
    
      after_promo  = Passant::Board.new(
              [ 'Q.......',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........'  ])
    
      board.should == after_promo
      mv.take_back
      board.should == Passant::Board.new(setting)
    end
  end

end
