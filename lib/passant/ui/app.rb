
require 'wx'
require 'passant/ui/main_frame'

module Passant::UI
  class App < Wx::App
    def on_init
      MainFrame.new
    end
  end
end
