class Rook < Piece
  def initialize(color)
    super(:rook, color)
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

    moves
  end
end
