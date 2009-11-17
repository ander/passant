require 'logger'

module Passant
  LOGGER = Logger.new(File.join(File.dirname(__FILE__), '..', '..', 
                      'passant.log'))
end