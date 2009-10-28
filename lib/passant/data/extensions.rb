require 'passant/data/data_store'
require 'passant/rules_engine'

module Passant
  
  class RulesEngine
    attr_reader :data_store
    
    alias_method :initialize_without_datastore, :initialize
    def initialize
      initialize_without_datastore
      @data_store = DataStore.new
    end
    
    alias_method :check_without_datastore, :check?
    def check?(board, color)
      stored = @data_store.check?(board, color)
      return stored unless stored.nil?
      value = check_without_datastore(board, color)
      @data_store.set_check(board, color, value)
      value
    end

    alias_method :checkmate_without_datastore, :checkmate?
    def checkmate?(board, color)
      stored = @data_store.checkmate?(board, color)
      return stored unless stored.nil?
      value = checkmate_without_datastore(board, color)
      @data_store.set_checkmate(board, color, value)
      value
    end

    alias_method :draw_without_datastore, :draw?
    def draw?(board, color)
      stored = @data_store.draw?(board, color)
      return stored unless stored.nil?
      value = draw_without_datastore(board, color)
      @data_store.set_draw(board, color, value)
      value
    end
    
  end
end
