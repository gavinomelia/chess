require_relative 'rook'
require_relative 'bishop'

class Queen < Piece
  def initialize(color)
    super(:queen, color)
  end

  def find_moves(position)
    Rook.new(color).find_moves(position) + Bishop.new(color).find_moves(position)
  end
end
