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
        moves << [new_x, new_y] if Board.on_board?(new_x, new_y)
      end
    end

    moves
  end
end
