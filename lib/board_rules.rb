require_relative 'board'

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
    return false unless on_board?(x, y)
    return false unless path_clear?(previous_position, new_position, piece.color) || piece.is_a?(Knight)
    return false unless valid_piece_move?(piece, previous_position, new_position)

    true
  end

  def on_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
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

    !@board.friendly_piece?(x2, y2, color)
  end

  def filter_moves(piece, moves)
    moves.select { |move| legal_move?(piece, move) }
  end

  private

  def valid_piece_move?(piece, previous_position, new_position)
    case piece
    when Pawn
      valid_pawn_move?(piece, previous_position, new_position)
    when Rook
      valid_rook_move?(piece, previous_position, new_position)
    when Bishop
      valid_bishop_move?(piece, previous_position, new_position)
    when Queen
      valid_queen_move?(piece, previous_position, new_position)
    when Knight
      valid_knight_move?(piece, previous_position, new_position)
    else
      false
    end
  end

  def valid_pawn_move?(pawn, previous_position, new_position)
    x, y = new_position
    dx = x - previous_position[0]
    dy = y - previous_position[1]
    direction = pawn.direction

    if dx == direction && dy.zero?
      @board.empty?(x, y)
    elsif dx == direction && dy.abs == 1
      @board.enemy_piece?(x, y, pawn.color)
    elsif on_starting_row?(pawn.color, previous_position) && dx == 2 * direction && dy.zero?
      intermediate_x = previous_position[0] + direction
      @board.empty?(x, y) && @board.empty?(intermediate_x, y)
    else
      false
    end
  end

  def on_starting_row?(color, position)
    (color == :white && position[0] == 6) || (color == :black && position[0] == 1)
  end

  def valid_rook_move?(rook, previous_position, new_position)
    x, y = new_position
    dx = x - previous_position[0]
    dy = y - previous_position[1]

    return false if dx.zero? && dy.zero?
    return false unless dx.zero? || dy.zero?

    true
  end

  def valid_bishop_move?(bishop, previous_position, new_position)
    x, y = new_position
    dx = x - previous_position[0]
    dy = y - previous_position[1]

    return false if dx.zero? && dy.zero?
    return false unless dx.abs == dy.abs

    true
  end

  def valid_queen_move?(queen, previous_position, new_position)
    valid_bishop_move?(queen, previous_position,
                       new_position) || valid_rook_move?(queen, previous_position, new_position)
  end

  def valid_knight_move?(knight, previous_position, new_position)
    x, y = new_position
    !@board.friendly_piece?(x, y, knight.color)
  end
end
