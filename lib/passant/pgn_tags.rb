
require 'date'

module Passant
  
  # Adds support for handling PGN tags.
  module PGNTags
    
    def tags
      @tags ||= {'Event'  => 'a new game',
                 'Site'   => '??',
                 'Date'   => Date.today.strftime('%Y.%m.%d'),
                 'Round'  => '??',
                 'White'  => '??,??',
                 'Black'  => '??,??',
                 'Result' => '*' # ongoing
                }
    end
    
    def result; self.tags['Result'] end
    def event; self.tags['Event'] end
    
    def result=(r)
      @tags = self.tags.merge({'Result' => r})
    end
    
    def pgn_tags
      
    end

  end
end
