
require 'date'

module Passant
  
  module PGN
    
    class Tag
      attr_accessor :value
      attr_reader :key
      
      def initialize(key, value)
        @key, @value = key, value
      end
      
      def self.required
        [ Tag.new('Event',  'a new game'),
          Tag.new('Site',   '??'),
          Tag.new('Date',   Date.today.strftime('%Y.%m.%d')),
          Tag.new('Round',  '??'),
          Tag.new('White',  '??,??'),
          Tag.new('Black',  '??,??'),
          Tag.new('Result', '*') ]
      end
      def to_pgn; "[#{@key} \"#{@value}\"]" end
    end
    
    module Support
      def tags
        @tags ||= Tag.required 
      end
      
      def pgn_result; self.tags[6].value end
      def pgn_result=(r); self.tags[6].value = r end
      
      def pgn_tags; tags.map{|t| t.to_pgn}.join("\n") end
    end
  end
end
