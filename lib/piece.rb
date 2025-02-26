class Piece
  attr_reader :type, :color, :board

  def initialize(type, color, board)
    @type = type
    @color = color
    @board = board
  end

  def move(new_position)
    @board.move_piece(self, new_position)
  end

  def on_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end
end