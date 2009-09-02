require 'passant/board'

describe Passant::Pawn do
  describe "#moves" do
    it "should return one step forward" do
      board = Passant::Board.new_empty
      p = Passant::Pawn.new(board, a2)
      p.moves.map{|m| m.to}.should include(a3)
    end

    it "should return two steps forward if not moved before" do
      board = Passant::Board.new_empty
      p = Passant::Pawn.new(board, a2)
      p.should_receive(:moved?).once.and_return(false)
      p.moves.map{|m| m.to}.should include(a4)
    end
    
    it "should not return two steps forward if moved before" do
      board = Passant::Board.new_empty
      p = Passant::Pawn.new(board, a2)
      p.should_receive(:moved?).once.and_return(true)
      p.moves.map{|m| m.to}.should_not include(a4)
    end

    it "should return a capture when possible" do
      board = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '....p...',
                '...P....',
                '........',
                '........'  ])
      white_pawn = board.at(d3)
      black_pawn = board.at(e4)
      white_pawn.moves.map{|m| m.to}.should include(e4)
      black_pawn.moves.map{|m| m.to}.should include(d3)
    end
    
    it "should return a capture when possible, part 2" do
      board = Passant::Board.new(
              [ '........',
                '........',
                '........',
                '........',
                '..p.....',
                '...P....',
                '........',
                '........'  ])
      white_pawn = board.at(d3)
      black_pawn = board.at(c4)
      white_pawn.moves.map{|m| m.to}.should include(c4)
      black_pawn.moves.map{|m| m.to}.should include(d3)
    end

    it "should create a promotion when advancing to last rank" do
      board = Passant::Board.new(
              [ '........',
                'P.......',
                '........',
                '........',
                '........',
                '........',
                '.p......',
                '........'  ])
      white_pawn = board.at(a7)
      black_pawn = board.at(b2)
      white_pawn.moves.map{|m| m.class}.should == [Passant::Promotion]
      black_pawn.moves.map{|m| m.class}.should == [Passant::Promotion]
    end

  end
end
