require_relative '../piece'

class Pawn < Piece
  MOVES = { initial: [[1, 0], [2, 0]], regular: [[1, 0]], captures: [[1, 1], [1, -1]] }.freeze
  WHITE_DIRECTION = 1
  BLACK_DIRECTION = -1

  def initialize(color)
    super(:pawn, color)
    @direction = color == :white ? WHITE_DIRECTION : BLACK_DIRECTION
  end

  def pawn_moves(position)
    if on_starting_row?(position)
      MOVES[:initial].map { |dx, dy| [dx * @direction, dy] }
    else
      MOVES[:regular].map { |dx, dy| [dx * @direction, dy] }
    end
  end

  def pawn_captures
    MOVES[:captures].map { |dx, dy| [dx * @direction, dy] }
  end

  def on_starting_row?(position)
    (color == :white && position[0] == 1) || (color == :black && position[0] == 6)
  end

  def find_moves(position)
    regular_moves(position) + capture_moves(position)
  end

  def regular_moves(position)
    x, y = position
    moves = []

    pawn_moves(position).each do |(dx, dy)|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if Board.on_board?(new_x, new_y) # && @board.empty?(new_x, new_y)
    end

    moves
  end

  def capture_moves(position)
    x, y = position
    moves = []

    pawn_captures.each do |(dx, dy)|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if Board.on_board?(new_x, new_y) # && @board.enemy_piece?(new_x, new_y, color)
    end

    moves
  end
end
