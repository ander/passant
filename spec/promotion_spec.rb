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

    mv = board.at(a7).moves.first
    mv.should be_kind_of(Promotion)
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

end
