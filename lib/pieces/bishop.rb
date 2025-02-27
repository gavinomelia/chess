class Bishop < Piece
  def initialize(color, board)
    super(:bishop, color, board)
  end

  def find_moves(position)
    x, y = position
    moves = []

    (-7..7).each do |i|
      next if i.zero?

      moves << [x + i, y + i]
      moves << [x + i, y - i]
    end

    filter_moves(moves)
  end
end
