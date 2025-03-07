class Queen < Piece
  def initialize(color)
    super(:queen, color)
  end

  def find_moves(position)
    x, y = position
    moves = []

    # Horizontal moves
    (0..7).each do |offset|
      moves << [x, offset] unless offset == y
    end

    # Vertical moves
    (0..7).each do |offset|
      moves << [offset, y] unless offset == x
    end

    # Diagonal moves
    (-7..7).each do |offset|
      next if offset.zero?

      moves << [x + offset, y + offset] if Board.on_board?(x + offset, y + offset)
      moves << [x + offset, y - offset] if Board.on_board?(x + offset, y - offset)
    end

    moves
  end
end
