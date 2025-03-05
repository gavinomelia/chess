class King < Piece
  MOVES = [
    [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]
  ]

  def initialize(color)
    super(:king, color)
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
