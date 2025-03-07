class Rook < Piece
  attr_accessor :moved

  def initialize(color)
    super(:rook, color)
    @moved = false
  end

  def find_moves(position)
    row, col = position
    moves = []

    # Horizontal moves
    (0..7).each do |i|
      moves << [row, i] unless i == col
    end

    # Vertical moves
    (0..7).each do |i|
      moves << [i, col] unless i == row
    end

    moves
  end
end
