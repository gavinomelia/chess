require_relative '../board'

class Knight < Piece
  KNIGHT_MOVES = [
    [2, 1], [2, -1], [-2, 1], [-2, -1],
    [1, 2], [1, -2], [-1, 2], [-1, -2]
  ].freeze

  def initialize(color, start_position, board)
    super(:knight, color, start_position, board)
  end

  def find_moves(start)
    possible_moves(start)
  end

  def possible_moves(position)
    x, y = position
    KNIGHT_MOVES.each_with_object([]) do |(dx, dy), moves|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if on_board?(new_x, new_y)
    end
  end
end
