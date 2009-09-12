
module Passant::UI
  
  def self.img_path(name)
    File.join File.dirname(__FILE__), 'images', "#{name}.png"
  end
  
end
