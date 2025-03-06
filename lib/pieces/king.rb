class King < Piece
  attr_accessor :moved

  MOVES = [
    [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]
  ]

  def initialize(color)
    super(:king, color)
    @moved = false
  end

  def find_moves(position)
    x, y = position
    moves = []

    MOVES.each do |(dx, dy)|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if Board.on_board?(new_x, new_y)
    end

    moves
  end
end
