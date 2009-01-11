require File.dirname(__FILE__)+"/../lib/board.rb"

describe Promotion do
  it "should promote a pawn" do    
    board = Board.new(
              [ '........',
                'P.......',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........'  ])

    mv = Promotion.new(board.at(a7), a8)
    mv.apply
    
    after_promo  = Board.new(
              [ 'Q.......',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........',
                '........'  ])
    
    board.should == after_promo
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
      
      board = Board.new(setting)
      
      mv = Promotion.new(board.at(a7), a8)
      mv.apply
    
      after_promo  = Board.new(
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
      board.should == Board.new(setting)
    end
  end

end
