
require 'yaml'

module Passant
  
  class DataStore
    STORE_PATH = File.dirname(__FILE__)+'/board_data.yml'

    def initialize
      @data = {}
      read
    end

    def read
      if File.exists?(STORE_PATH)
        @data = YAML.load(File.read(STORE_PATH))
      end
    end

    def write
      File.open(STORE_PATH, 'w+') do |f|
        f.write YAML.dump(@data)
      end
    end

    def check?(board, color)
      return nil unless @data[board.to_s]
      @data[board.to_s]["check_#{color}"]
    end

    def draw?(board, color)
      return nil unless @data[board.to_s]
      @data[board.to_s]["draw_#{color}"]
    end
    
    def checkmate?(board, color)
      return nil unless @data[board.to_s]
      @data[board.to_s]["checkmate_#{color}"]
    end
    
    def set_check(board, color, value)
      @data[board.to_s] ||= {}
      @data[board.to_s]["check_#{color}"] = value
    end

    def set_draw(board, color, value)
      @data[board.to_s] ||= {}
      @data[board.to_s]["draw_#{color}"] = value
    end
    
    def set_checkmate(board, color, value)
      @data[board.to_s] ||= {}
      @data[board.to_s]["checkmate_#{color}"] = value
    end

  end

end
