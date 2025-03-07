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
    (0..7).each do |offset|
      moves << [row, offset] unless offset == col
    end

    # Vertical moves
    (0..7).each do |offset|
      moves << [offset, col] unless offset == row
    end

    moves
  end
end
