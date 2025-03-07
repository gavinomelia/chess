class Bishop < Piece
  def initialize(color)
    super(:bishop, color)
  end

  def find_moves(position)
    col, row = position
    moves = []

    (-7..7).each do |offset|
      next if offset.zero?

      new_positions = [[col + offset, row + offset], [col + offset, row - offset]]
      new_positions.each do |new_col, new_row|
        moves << [new_col, new_row] if Board.on_board?(new_col, new_row)
      end
    end

    moves
  end
end
