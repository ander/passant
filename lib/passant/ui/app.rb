
require 'wx'
require 'passant/ui/board'

module Passant::UI
  class App < Wx::App
    def on_init
      Board.new
    end
  end
end
