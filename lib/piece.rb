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
end