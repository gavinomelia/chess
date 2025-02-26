class Knight < Piece
  KNIGHT_MOVES = [
    [2, 1], [2, -1], [-2, 1], [-2, -1],
    [1, 2], [1, -2], [-1, 2], [-1, -2]
  ].freeze

  def initialize(color, start_position)
    super(:knight, color, start_position)
  end

  def find_knight_moves(start)
    possible_moves(start)
  end

  def possible_moves(position)
    x, y = position
    KNIGHT_MOVES.each_with_object([]) do |(dx, dy), moves|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if valid_move?(new_x, new_y)
    end
  end

  def valid_move?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end
end
