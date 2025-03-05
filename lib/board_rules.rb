# frozen_string_literal: true

require_relative 'board'

# This class is responsible for determining the valid moves for a piece and whether a move is legal.
# It uses piece-specific methods to determine a piece's possible moves and then filters them based on the board state.
class BoardRules
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def valid_moves(piece)
    position = @board.find_piece(piece)
    unvalidated_moves = piece.find_moves(position)
    filter_moves(piece, unvalidated_moves)
  end

  def legal_move?(piece, new_position)
    x, y = new_position
    previous_position = @board.find_piece(piece)
    return false unless Board.on_board?(x, y)
    return false if takes_friendly_piece?(piece, new_position)
    return false unless path_clear?(previous_position, new_position, piece.color) || piece.is_a?(Knight)
    return false unless valid_piece_move?(piece, previous_position, new_position)

    true
  end

  def path_clear?(start_pos, end_pos, color)
    start_x, start_y = start_pos
    x2, y2 = end_pos

    x_step = x2 <=> start_x
    y_step = y2 <=> start_y

    current_x = start_x + x_step
    current_y = start_y + y_step

    while [current_x, current_y] != [x2, y2]
      return false unless @board.empty?(current_x, current_y)

      current_x += x_step
      current_y += y_step
    end

    @board.empty?(x2, y2) || @board.enemy_piece_at?(x2, y2, color)
  end

  def takes_friendly_piece?(piece, new_position)
    x, y = new_position
    @board.friendly_piece_at?(x, y, piece.color)
  end

  def filter_moves(piece, moves)
    moves.select { |move| legal_move?(piece, move) }
  end

  def in_check?(color)
    king = @board.find_king(color)
    king_position = @board.find_piece(king)

    @board.grid.flatten.any? do |piece|
      next if piece.nil?
      next if piece.color == color

      piece.find_moves(@board.find_piece(piece)).include?(king_position)
    end
  end

  def move_into_check?(old_position, new_position, color)
    # Returns true if the move would result in that color being in check
    @board.temporarily_move_piece(old_position, new_position) do
      in_check?(color)
    end
  end

  private

  def valid_piece_move?(piece, previous_position, new_position)
    case piece
    when Pawn
      valid_pawn_move?(piece, previous_position, new_position)
    when Rook
      valid_rook_move?(previous_position, new_position)
    when Bishop
      valid_bishop_move?(previous_position, new_position)
    when Queen
      valid_queen_move?(previous_position, new_position)
    when Knight
      # There are currently no restrictions on knight moves that depend on board state besides
      # taking a friendly piece which is already handled.
      true
    else
      false
    end
  end

  def valid_pawn_move?(pawn, previous_position, new_position)
    x, y = new_position
    dx = x - previous_position[0]
    dy = y - previous_position[1]
    direction = pawn.direction

    return true if dx == direction && dy.zero? && @board.empty?(x, y)
    return true if dx == direction && dy.abs == 1 && @board.enemy_piece_at?(x, y, pawn.color)
    return true if on_starting_row?(pawn.color,
                                    previous_position) && dx == 2 * direction && dy.zero? && @board.empty?(x, y)

    false
  end

  def on_starting_row?(color, position)
    (color == :white && position[0] == 6) || (color == :black && position[0] == 1)
  end

  def valid_rook_move?(previous_position, new_position)
    x, y = new_position
    dx = x - previous_position[0]
    dy = y - previous_position[1]

    return false if dx.zero? && dy.zero?
    return false unless dx.zero? || dy.zero?

    true
  end

  def valid_bishop_move?(previous_position, new_position)
    x, y = new_position
    dx = x - previous_position[0]
    dy = y - previous_position[1]

    return false if dx.zero? && dy.zero?
    return false unless dx.abs == dy.abs

    true
  end

  def valid_queen_move?(previous_position, new_position)
    valid_bishop_move?(previous_position,
                       new_position) || valid_rook_move?(previous_position, new_position)
  end
end
