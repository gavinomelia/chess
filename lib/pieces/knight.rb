class Knight < Piece
  KNIGHT_MOVES = [
    [2, 1], [2, -1], [-2, 1], [-2, -1],
    [1, 2], [1, -2], [-1, 2], [-1, -2]
  ].freeze

  def initialize(color)
    super(:knight, color)
  end

  def find_moves(position)
    row, col = position
    KNIGHT_MOVES.each_with_object([]) do |(change_in_row, change_in_col), moves|
      new_row = row + change_in_row
      new_col = col + change_in_col
      moves << [new_row, new_col] if Board.on_board?(new_row, new_col)
  end
end
