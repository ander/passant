require 'singleton'

module Passant
  class MoveParser
    include Singleton
    
    class ParseError < StandardError; end
    
    # = Move Parsing 
    # If 'to' is nil, move is parsed from a string.
    #
    # Example cases:
    # e4     : e-row pawn to e4 (from e2 or e3)
    # Be3    : bishop to e3
    # O-O    : castling, king-side
    # exd5   : e-row pawn captures d5. just 'xd5' not allowed.
    # Nxd5   : knight captures d5
    # h8=Q   : promotion
    # e2e4   : move using just square coordinates
    # Nexc4  : knight from e-column captures c4
    # N2xc4  : knight from row 2 captures c4
    # O-O-O  : castling, queen-side
    # Ne2c3  : knight from e2 to c3
    # Ne2xc3 : knight from e2 captures c3
    #
    # plus possible trailing + or # or !
    def parse(board, color, move_str)
      str = move_str.gsub(/[+\#!]/, '')
      capture = str.delete!('x')

      # the promotion piece setting, e.g. h8=Q
      if str =~ /^.*(=.).*$/
        Pawn.set_promotion_piece(color, 
          Board::PieceLetterMap.detect{|k,v| v.include?($1[1,1])}[0])
        str.gsub!($1, '')
      end
        
      case str.length
      when 2
        move_to = send(str)
        piece_pos = [move_to[0], move_to[1] - Piece.advance_direction(color)]
        piece = board.at(piece_pos)
        piece ||= board.at([piece_pos[0], 
                            piece_pos[1] - Piece.advance_direction(color)])
          
        mv = piece ? piece.moves.detect{|m| m.to == move_to} : nil
          
      when 3
        if str == 'O-O'
          mv = board.king(color).moves.detect{|m| m.to_s == 'O-O'}
        else
          c = str[0,1]
          move_to = send(str[1,2])
        
          if c == c.capitalize
            klass = Board::PieceLetterMap.detect{|k,v| v.include?(c)}[0]
            moves = board.pieces.select do |p|
              p.class == klass and p.color == color
            end.map(&:moves).flatten
            mv = moves.detect{|m| m.to == move_to}
          elsif capture
            x_diff = str[0,1] > str[1,1] ? 1 : -1
              
            pieces = board.pieces.select do |p| 
              p.class == Pawn and p.color == color and \
                p.x == move_to[0] + x_diff
            end
              
            mv = pieces.map{|p| p.moves}.flatten.detect{|m| [move_to, [move_to[0], move_to[1]+m.piece.advance_direction]].include?(m.to)}
          end
        end
          
      when 4
        c = str[0,1]
        move_to = send(str[2,2])
          
        if c == c.capitalize
          klass = Board::PieceLetterMap.detect{|k,v| v.include?(c)}[0]
          x_diff = nil
          y_pos = nil
          if str[1,1] <= '9'
            y_pos = str[1,1].to_i - 1
          else
            x_diff = str[1] - str[2]
          end
          piece = board.pieces.detect do |p|
            p.class == klass and p.color == color and \
              (x_diff ? p.x == move_to[0] + x_diff : p.y == y_pos)
          end
          mv = piece ? piece.moves.detect{|m| m.to == move_to} : nil
        else
          move_from = send(str[0,2])
          piece = board.at(move_from)
          mv = piece ? piece.moves.detect{|m| m.to == move_to} : nil
        end
          
      when 5
        if str == 'O-O-O'
          mv = board.king(color).moves.detect{|m| m.to_s == 'O-O-O'}
        else
          move_from = send(str[1,2])
          move_to = send(str[3,2])
          piece = board.at(move_from)
          mv = piece ? piece.moves.detect{|m| m.to == move_to} : nil
        end
      end
      
      raise ParseError.new("Invalid move: #{from}") if mv.nil?
      
      mv
    end
  end

end