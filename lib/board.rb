class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8, 0) }
  end

  # Checks if a piece exists at the given coordinates
  def piece_at?(x, y)
    !@board[x][y].zero?
  end
end