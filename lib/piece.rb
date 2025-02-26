class Piece
  attr_reader :type, :color, :position, :board

  def initialize(type, color, start_position, board)
    @type = type
    @color = color
    @position = start_position
    @board = board
  end

  def move(new_position)
    @position = new_position
  end

  def on_board?(x, y)
    x.between?(0, 8) && y.between?(0, 8)
  end
end