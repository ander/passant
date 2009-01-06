=begin rdoc

Define the chessboard coordinates.

=end

%w(a b c d e f g h).each_with_index do |letter, x|
  %w(1 2 3 4 5 6 7 8).each_with_index do |num, y|
    eval %Q(def #{letter}#{num}; [#{x}, #{y}]; end)
  end
end

def chess_coords(pos)
  "abcdefgh"[pos[0]..pos[0]] + pos[1].to_s
end
