# frozen_string_literal: true

# Represents a pawn in a chess game.
class Pawn < Piece
  WHITE_DIRECTION = -1
  BLACK_DIRECTION = 1

  def initialize(color)
    super(:pawn, color)
  end

  def find_moves(position)
    pawn_moves(position)
  end

  def direction
    @color == :white ? WHITE_DIRECTION : BLACK_DIRECTION
  end

  private

  def pawn_moves(position)
    row, col = position
    moves = [
      [row + direction, col],       # Single forward move
      [row + (2 * direction), col], # Double forward move (first move only)
      [row + direction, col + 1],   # Capture diagonally right
      [row + direction, col - 1]    # Capture diagonally left
    ]
    on_board_moves(moves)
  end

  def on_board_moves(moves)
    moves.select { |move| Board.on_board?(move[0], move[1]) }
  end
end
