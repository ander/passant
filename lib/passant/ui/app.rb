
require 'wx'
require 'passant/ui/main_frame'

module Passant::UI
  class App < Wx::App
    def on_init
      Wx::Timer.every(50) { Thread.pass }
      MainFrame.new
    end
  end
end
