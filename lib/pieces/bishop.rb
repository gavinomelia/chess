require_relative '../piece'

class Bishop < Piece
  def initialize(color)
    super(:bishop, color)
  end

  def find_moves(position)
    x, y = position
    moves = []

    (-7..7).each do |i|
      next if i.zero?

      new_positions = [[x + i, y + i], [x + i, y - i]]
      new_positions.each do |new_x, new_y|
        moves << [new_x, new_y] if new_x.between?(0, 7) && new_y.between?(0, 7)
      end
    end

    moves
  end
end
