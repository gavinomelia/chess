class Knight < Piece
  KNIGHT_MOVES = [
    [2, 1], [2, -1], [-2, 1], [-2, -1],
    [1, 2], [1, -2], [-1, 2], [-1, -2]
  ].freeze

  def initialize(color)
    super(:knight, color)
  end

  def find_moves(position)
    col, row = position
    KNIGHT_MOVES.each_with_object([]) do |(dx, dy), moves|
      new_col = col + dx
      new_row = row + dy
      moves << [new_col, new_row] if Board.on_board?(new_col, new_row)
    end
  end
end
