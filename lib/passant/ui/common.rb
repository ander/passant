
module Passant::UI

  def self.bitmapify(img_file)
    Wx::Bitmap.from_image(Wx::Image.new(img_path(img_file)))
  end

  def self.img_path(img_file)
    File.join File.dirname(__FILE__), 'images', "#{img_file}"
  end
  
end
