require_relative '../piece'

class Queen < Piece
  def initialize(color)
    super(:queen, color)
  end

  def find_moves(position)
    x, y = position
    moves = []

    # Horizontal moves
    (0..7).each do |i|
      moves << [x, i] unless i == y
    end

    # Vertical moves
    (0..7).each do |i|
      moves << [i, y] unless i == x
    end

    # Diagonal moves
    (-7..7).each do |i|
      next if i.zero?

      moves << [x + i, y + i] if Board.on_board?(x + i, y + i)
      moves << [x + i, y - i] if Board.on_board?(x + i, y - i)
    end

    moves
  end
end
