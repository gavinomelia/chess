class Pawn < Piece
  INITIAL_PAWN_MOVES = [[1,0], [2, 0]].freeze
  PAWN_MOVES = [[1, 0]].freeze
  PAWN_CAPTURES = [[1, 1], [1, -1]].freeze

  def initialize(color, start_position)
    super(:pawn, color, start_position)
  end

  def find_moves(start)
    possible_moves(start)
  end

  def pawn_moves
    return INITIAL_PAWN_MOVES if on_starting_row?
    PAWN_MOVES
  end

  def on_starting_row?
    (color == :white && position[0] == 1) || (color == :black && position[0] == 6)
  end

  def possible_moves(start)
    x, y = start
    moves = []

    pawn_moves.each do |(dx, dy)|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if on_board?(new_x, new_y)
    end

    moves
  end
end