class Rook < Piece
  attr_accessor :moved

  def initialize(color)
    super(:rook, color)
    @moved = false
  end

  def find_moves(position)
    col, row = position
    moves = []

    # Horizontal moves
    (0..7).each do |offset|
      moves << [col, offset] unless offset == row
    end

    # Vertical moves
    (0..7).each do |offset|
      moves << [offset, row] unless offset == col
    end

    moves
  end
end
