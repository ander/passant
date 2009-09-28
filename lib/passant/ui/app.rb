
require 'wx'
require 'passant/ui/main_frame'

module Passant::UI
  class App < Wx::App
    
    def on_init
      Thread.abort_on_exception = true
      Wx::Timer.every(50) { Thread.pass }
      @main = MainFrame.new
    end
    
    # give a block to execute in a thread while UI 
    # pulses its progress indicator
    def responsively
      result = nil
      
      t = Thread.new do
        begin
          result = yield
          Thread.exit
        rescue Passant::Board::Exception, Passant::Move::Invalid => e
          @main.set_status(e.message)
        end
      end
      
      while t.alive?
        @main.pulse
        sleep(0.1)
      end
      
      @main.ready
      result
    end
  end
end
