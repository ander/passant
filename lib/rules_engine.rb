=begin rdoc

Contains most of the rules logic.

=end

class RulesEngine
  def initialize(board)
    @board = board
  end

  # check if a piece can move to a square
  # blocked if own piece in square or enemy piece and
  # can_capture == false
  def valid_move?(move, can_capture=true, recurse=true)
    return false if (recurse and ignores_or_causes_self_check?(move))
    content = @board.at(move.to)
    return true unless content
    return (move.piece.enemy?(content) and can_capture)
  end
  
  # check also the squares in between for blockers
  def valid_linear_move?(move, can_capture=true, recurse=true)
    return false if (recurse and ignores_or_causes_self_check?(move))
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
      content = @board.at(sq)
      if content
        return false if !piece.enemy?(content) or !can_capture
        return false if i < squares.size-1 # can't jump over pieces
      end
    end
    return true
  end

  def en_passant(pawn)
    return nil
  end

  def fortifications(king)
    return [] if king.moved?
    # ...
    return []
  end
  
  # is it check for color? (color's turn)
  def check?(color)
    king = @board.king(color)
    return false unless king
    
    enemy_moves = @board.all_moves(king.enemy_color, false).map{|m| m.to}
    return enemy_moves.include?(king.position)
  end

  def check_mate?(color)
    check?(color) and @board.all_moves(color, true).empty?
  end

  def draw?(color)
    !check?(color) and @board.all_moves(color, true).empty?
  end

  private
  
  def ignores_or_causes_self_check?(move)
    new_board = @board.after_move(move)
    new_board.rules.check?(move.piece.color)
  end

end
