require_relative '../piece'

class Pawn < Piece
  INITIAL_WHITE_PAWN_MOVES = [[1, 0], [2, 0]].freeze
  WHITE_PAWN_MOVES = [[1, 0]].freeze
  WHITE_PAWN_CAPTURES = [[1, 1], [1, -1]].freeze

  INITIAL_BLACK_PAWN_MOVES = [[-1, 0], [-2, 0]].freeze
  BLACK_PAWN_MOVES = [[-1, 0]].freeze
  BLACK_PAWN_CAPTURES = [[-1, 1], [-1, -1]].freeze

  def initialize(color, board)
    super(:pawn, color, board)
  end

  def find_moves(position)
    possible_moves(position)
  end

  def pawn_moves(position)
    if color == :white
      return INITIAL_WHITE_PAWN_MOVES if on_starting_row?(position)
      WHITE_PAWN_MOVES
    else
      return INITIAL_BLACK_PAWN_MOVES if on_starting_row?(position)
      BLACK_PAWN_MOVES
    end
  end

  def pawn_captures
    color == :white ? WHITE_PAWN_CAPTURES : BLACK_PAWN_CAPTURES
  end

  def on_starting_row?(position)
    (color == :white && position[0] == 1) || (color == :black && position[0] == 6)
  end

  def possible_moves(position)
    x, y = position
    moves = []

    pawn_moves(position).each do |(dx, dy)|
      new_x = x + dx
      new_y = y + dy
      moves << [new_x, new_y] if on_board?(new_x, new_y) && @board.empty?(new_x, new_y)
    end

    pawn_captures.each do |(dx, dy)|
      new_x = x + dx
      new_y = y + dy
      if on_board?(new_x, new_y) && @board.enemy_piece?(new_x, new_y, color)
        moves << [new_x, new_y]
      end
    end

    moves
  end
end