
require 'singleton'

module Passant
  
  # Contains most of the rules logic.
  class RulesEngine
    include Singleton

    # check if a piece can move to a square
    # blocked if own piece in square or enemy piece and
    # can_capture == false
    def valid_move?(board, move, can_capture=true, recurse=true)
      return false if (recurse and ignores_or_causes_self_check?(board, move))
      content = board.at(move.to)
      unless content
        true
      else
        move.piece.enemy?(content) and can_capture
      end
    end
    
    # check also the squares in between for blockers
    def valid_linear_move?(board, move, can_capture=true, recurse=true)
      return false if (recurse and ignores_or_causes_self_check?(board, move))
      piece = move.piece
      x_coords = \
        piece.x.send(piece.x < move.to[0] ? :upto : :downto, move.to[0]).map
      y_coords = \
        piece.y.send(piece.y < move.to[1] ? :upto : :downto, move.to[1]).map

      raise "Invalid line!" if (x_coords.size > 1) and (y_coords.size > 1) and \
        (x_coords.size != y_coords.size)
    
      if x_coords.size > y_coords.size
        y_coords.fill(piece.y, 1, x_coords.size - y_coords.size)
      elsif y_coords.size > x_coords.size
        x_coords.fill(piece.x, 1, y_coords.size - x_coords.size)
      end
      squares = x_coords.zip(y_coords)
      squares.shift # remove the starting square
    
      squares.each_with_index do |sq,i|
        content = board.at(sq)
        if content
          return false if !piece.enemy?(content) or !can_capture
          return false if i < squares.size-1 # can't jump over pieces
        end
      end
      return true
    end
    
    def en_passant(board, pawn)
      last_mv = board.history.last
      if last_mv and \
        last_mv.piece.is_a?(Pawn) and \
        pawn.enemy?(last_mv.piece) and \
        (last_mv.from[1] - last_mv.to[1]).abs == 2 and \
        (last_mv.piece.position == [pawn.x+1, pawn.y] or \
         last_mv.piece.position == [pawn.x-1, pawn.y])
        return EnPassant.new(pawn, 
                             [last_mv.piece.x, pawn.y + pawn.advance_direction])
      end
      return nil
    end
    
    def castlings(board, king)
      return [] if king.moved?
      moves = []
      row = (king.white? ? 0 : 7)
      
      if (rook = board.at([0,row])) and \
        rook.is_a?(Rook) and \
        rook.color == king.color and \
        !rook.moved? and \
        board.at([1, row]).nil? and \
        board.at([2, row]).nil? and \
        board.at([3, row]).nil? and \
        (board.all_moves(king.enemy_color, false, false).\
         map{|m| m.to} & [[2,row],[3,row],[4,row]]).empty?
        moves << Castling.new(king, [2,row])
      end
    
      if (rook = board.at([7,row])) and \
        rook.is_a?(Rook) and \
        rook.color == king.color and \
        !rook.moved? and \
        board.at([5,row]).nil? and \
        board.at([6,row]).nil? and \
        (board.all_moves(king.enemy_color, false, false).\
         map{|m| m.to} & [[5,row],[6,row]]).empty?
        moves << Castling.new(king, [6,row])
      end
      
      return moves
    end
  
    # is it check for color? (color's turn)
    def check?(board, color)
      king = board.king(color)
      return false unless king
    
      enemy_moves = board.all_moves(king.enemy_color, false).map{|m| m.to}
      return enemy_moves.include?(king.position)
    end

    def checkmate?(board, color)
      check?(board, color) and board.all_moves(color, true).empty?
    end

    def draw?(board, color)
      !check?(board, color) and board.all_moves(color, true).empty?
    end

    private
  
    def ignores_or_causes_self_check?(board, move)
      new_board = board.after_move(move)
      new_board.check?(move.piece.color)
    end
    
  end

end
