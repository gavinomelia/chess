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
    row, col = position
    moves = []

    MOVES.each do |(row_change, col_change)|
      new_row = row + row_change
      new_col = col + col_change
      moves << [new_row, new_col] if Board.on_board?(new_row, new_col)
    end

    moves
  end
end
