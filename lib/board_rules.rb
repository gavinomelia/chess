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
    col, row = new_position
    previous_position = @board.find_piece(piece)

    return false unless Board.on_board?(col, row)
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
    col, row = new_position
    @board.friendly_piece_at?(col, row, piece.color)
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

  def stalemate?(color)
    return false if in_check?(color)

    # Check if any piece of this color can make a legal move
    @board.pieces_of_color(color).all? do |piece|
      valid_moves(piece).empty?
    end
  end

  def able_to_castle?(direction, color)
    king = @board.find_king(color)
    king_position = @board.find_piece(king)
    king_col, king_row = king_position

    rook_column = direction == :queenside ? 0 : 7
    rook = @board.find_rook(color, rook_column)

    return false if in_check?(color) || king.moved || rook.moved

    # Check if path between king and rook is clear
    range = direction == :queenside ? (1...king_row) : (king_row + 1...7)
    return false unless range.all? { |row| @board.empty?(king_col, row) }

    # Check if king would move through check
    !moves_through_check?(color, king_position, [king_col, rook_column])
  end

  def square_under_attack?(color, position)
    @board.pieces_of_opposite_color(color).any? do |piece|
      valid_moves(piece).include?(position)
    end
  end

  def valid_en_passant?(pawn)
    # 1. The pawn being captured jumped two spaces as its last move
    # 2. The capturing pawn is on the same row as the captured pawn
    last_move = @board.last_move
    return false unless last_move

    last_piece = last_move[:piece]
    last_piece_previous_coordinates = last_move[:from]
    last_piece_current_coordinates = last_move[:to]

    last_piece_previous_row, _last_piece_previous_col = last_piece_previous_coordinates
    last_piece_current_row, _last_piece_current_col = last_piece_current_coordinates

    current_piece_coordinates = @board.find_piece(pawn)
    current_piece_row, _current_piece_col = current_piece_coordinates

    return false unless last_piece.is_a?(Pawn) && last_piece.color != pawn.color
    return false unless (last_piece_previous_row - last_piece_current_row).abs == 2
    return false unless last_piece_current_row == current_piece_row

    true
  end

  private

  def moves_through_check?(color, start_pos, end_pos)
    # Get direction vector
    x_step = (end_pos[0] - start_pos[0]) <=> 0
    y_step = (end_pos[1] - start_pos[1]) <=> 0

    # Create path of positions to check (excluding start position)
    path = []
    current_x, current_y = start_pos

    while end_pos != [current_x, current_y]
      current_x += x_step
      current_y += y_step

      path << [current_x, current_y]
    end

    # Check if any square in the path is under attack
    path.any? { |pos| square_under_attack?(color, pos) }
  end

  def valid_piece_move?(piece, previous_position, new_position)
    if piece.is_a?(Pawn)
      valid_pawn_move?(piece, previous_position, new_position)
    else
      true
    end
  end

  def valid_pawn_move?(pawn, previous_position, new_position)
    new_col, new_row = new_position
    column_change = new_col - previous_position[0]
    row_change = new_row - previous_position[1]
    direction = pawn.direction
    color = pawn.color

    return true if valid_pawn_advance?(column_change, row_change, direction, new_col, new_row)
    return true if valid_pawn_capture?(pawn, column_change, row_change, direction, new_col, new_row, color)
    return true if valid_pawn_double_advance?(column_change, row_change, direction, previous_position, new_col,
                                              new_row, color)

    false
  end

  def valid_pawn_advance?(dx, dy, direction, col, row)
    dx == direction && dy.zero? && @board.empty?(col, row)
  end

  def valid_pawn_capture?(pawn, dx, dy, direction, col, row, color)
    return true if valid_en_passant?(pawn)

    dx == direction && dy.abs == 1 && @board.enemy_piece_at?(col, row, color)
  end

  def valid_pawn_double_advance?(dx, dy, direction, previous_position, col, row, color)
    on_starting_row?(color, previous_position) && dx == 2 * direction && dy.zero? && @board.empty?(col, row)
  end

  def on_starting_row?(color, position)
    (color == :white && position[0] == 6) || (color == :black && position[0] == 1)
  end
end
