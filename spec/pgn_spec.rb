require 'passant/game_board'

describe Passant::PGN do
  
  describe "Game.parse_turn_or_ply" do
    it "should parse one move w/o comments" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4', b)
      b.last_move.should_not be_nil
    end
    
    it "should parse comments inside {}" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 {This is a comment.}', b)
      b.last_move.comment.should == 'This is a comment.'
    end
    
    it "should ignore result text" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 0-1', b)
      b.last_move.should_not be_nil
    end
    
    it "should parse comment after ;" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4; This is a comment.', b)
      b.last_move.comment.should == 'This is a comment.'
    end
    
    it "should parse comment after ; (2)" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 ; This is a comment.', b)
      b.last_move.comment.should == 'This is a comment.'
    end
    

    it "should parse two moves w/o comments" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 e5', b)
      b.last_move.to.should == e5
      b.take_back
      b.last_move.to.should == e4
    end

    it "should parse two moves, first with a comment" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 {This is a comment.} e5', b)
      b.last_move.to.should == e5
      b.last_move.comment.should be_nil
      b.take_back
      b.last_move.to.should == e4
      b.last_move.comment.should == 'This is a comment.'
    end

    it "should parse two moves, second with a comment" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 e5 {This is a comment.}', b)
      b.last_move.to.should == e5
      b.last_move.comment.should == 'This is a comment.'
      b.take_back
      b.last_move.to.should == e4
      b.last_move.comment.should be_nil
    end

    it "should parse two moves, second with semicolon comment" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 e5 ; This is a comment.', b)
      b.last_move.to.should == e5
      b.last_move.comment.should == 'This is a comment.'
      b.take_back
      b.last_move.to.should == e4
      b.last_move.comment.should be_nil
    end

    it "should parse two moves, both with comments" do
      b = Passant::GameBoard.new
      Passant::PGN::Game.parse_turn_or_ply('e4 {Comment 1} e5 {Comment 2}', b)
      b.last_move.to.should == e5
      b.last_move.comment.should == 'Comment 2'
      b.take_back
      b.last_move.to.should == e4
      b.last_move.comment.should == 'Comment 1'
    end

  end

end
