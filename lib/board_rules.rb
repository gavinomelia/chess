# frozen_string_literal: true

require_relative 'board'

# This class is responsible for determining the valid moves for a piece and whether a move is legal.
# It uses piece-specific methods to determine a piece's possible moves and then filters them based on the board state.
class BoardRules
  attr_reader :board

  def initialize(board)
    @board = board
    @skip_check_validation = false
  end

  def valid_moves(piece)
    position = @board.find_piece(piece)
    unvalidated_moves = piece.find_moves(position)
    filter_moves(piece, unvalidated_moves)
  end

  def filter_moves(piece, moves)
    moves.select { |move| legal_move?(piece, move) }
  end

  def legal_move?(piece, new_position)
    x, y = new_position
    previous_position = @board.find_piece(piece)

    return false unless Board.on_board?(x, y)
    return false if takes_friendly_piece?(piece, new_position)
    return false unless path_clear?(previous_position, new_position, piece.color) || piece.is_a?(Knight)
    return false unless valid_piece_move?(piece, previous_position, new_position)
    return false if !@skip_check_validation && moves_into_check?(piece, new_position)

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

  def in_check?(color)
    king = @board.find_king(color)
    return false unless king

    king_position = @board.find_piece(king)
    @skip_check_validation = true
    result = @board.pieces_of_opposite_color(color).any? do |piece|
      valid_moves(piece).include?(king_position)
    end
    @skip_check_validation = false
    result
  end

  def moves_into_check?(piece, new_position)
    old_position = @board.find_piece(piece)
    @board.temporarily_move_piece(old_position, new_position) do
      in_check?(piece.color)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    # Check if any piece of this color can make a move to get out of check
    @board.pieces_of_color(color).all? do |piece|
      valid_moves(piece).empty?
    end
  end

  private

  def valid_piece_move?(piece, previous_position, new_position)
    if piece.is_a?(Pawn)
      valid_pawn_move?(piece, previous_position, new_position)
    else
      true
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
end
