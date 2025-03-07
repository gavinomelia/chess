class Bishop < Piece
  def initialize(color)
    super(:bishop, color)
  end

  def find_moves(position)
    row, col = position
    moves = []

    (-7..7).each do |offset|
      next if offset.zero?

      new_positions = [[row + i, col + i], [row + i, col - i]]
      new_positions.each do |new_x, new_y|
        moves << [new_x, new_y] if Board.on_board?(new_x, new_y)
      end
    end

    moves
  end
end
