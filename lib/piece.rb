class Piece
  attr_accessor :color, :type, :position

  def initialize(type, color, position)
    @type = type
    @color = color
    @position = position
  end

  def move(new_position)
    @position = new_position
  end

  def on_board?(x, y)
    x.between?(0, 8) && y.between?(0, 8)
  end
end