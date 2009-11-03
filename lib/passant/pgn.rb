
require 'date'

module Passant
  
  module PGN

    # A PGN tagpair
    class TagPair
      attr_accessor :value
      attr_reader :key
      
      def initialize(key, value)
        @key = key || ''
        @value = value || ''
      end
      
      def self.required
        [ TagPair.new('Event',  'casual game'),
          TagPair.new('Site',   '?'),
          TagPair.new('Date',   Date.today.strftime('%Y.%m.%d')),
          TagPair.new('Round',  '?'),
          TagPair.new('White',  '?'),
          TagPair.new('Black',  '?'),
          TagPair.new('Result', '*') ]
      end
      def to_pgn; "[#{@key} \"#{@value}\"]" end
    end

    # Reflects a single PGN game that converts to a GameBoard
    class Game
      attr_reader :title, :tag_pairs
      
      def initialize(tag_pair_data, movetext)
        @movetext = movetext
        @tag_pairs = tag_pair_data.map do |tp|
          tp =~ /^\[([^\s]+)\s+"(.+)"\]$/
          TagPair.new($1,$2)
        end
        set_title
      end
      
      def to_board(board=nil)
        board ||= GameBoard.new
        board.tag_pairs = self.tag_pairs
        move_data = @movetext.split(/[0-9]+\.|[0-9]+\.\.\./)
        move_data.each do |md|
          next if md.length == 0
          parts = md.split
          board.move(parts[0])
          # TODO: handle comments
          if parts[1] and !%w(0-1 1-0 1/2-1/2).include?(parts[1])
            board.move(parts[1])
          end
        end
        board
      end
      
      private
      
      def set_title
        @title = format("%s %s: %s %s",
                        tag_pairs[2].value,
                        tag_pairs[0].value,
                        (tag_pairs[4].value.split(',').first + ' vs. '+
                        tag_pairs[5].value.split(',').first),
                        tag_pairs[6].value)
      end
    end
    
    # Reflects a PGN file which can contain multiple games.
    # See: http://en.wikipedia.org/wiki/Pgn
    class File
      def initialize(path)
        @file = ::File.new(path)
      end
      
      def games
        @games ||= begin
          games = []
          tag_pairs = []
          movetext = ''
          
          while line = @file.gets
            line.strip!
            next if line[0,1] == '%'
          
            if line[0,1] == '['
              tag_pairs << line
            elsif line.length == 0
              if tag_pairs.length > 0 and movetext.length > 0
                games << Game.new(tag_pairs, movetext)
                tag_pairs = []
                movetext = ''
              end
            else
              movetext += (line + ' ')
            end
          end
          
          games
        end
      end
    end
    
    # PGN support for a board
    module Support
      def tag_pairs
        @tag_pairs ||= TagPair.required 
      end
      def tag_pairs=(pairs); @tag_pairs = pairs end
      
      def pgn_result; self.tag_pairs[6].value end
      def pgn_result=(r); self.tag_pairs[6].value = r end
      
      def to_pgn
        tag_pairs.map{|t| t.to_pgn}.join("\n")
        # TODO: movetext
      end
    end
  end
end
