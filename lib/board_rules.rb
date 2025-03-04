require_relative 'board'

class BoardRules
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def valid_moves(piece)
    unvalidated_moves = piece.unvalidated_moves
    filter_moves(piece, unvalidated_moves)
  end

  def legal_move?(piece, new_position)
    x, y = new_position
    previous_position = @board.find_piece(piece)
    return false unless on_board?(x, y)
    return false unless path_clear?(previous_position, new_position, piece.color)
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

    @board.empty?(x2, y2) || @board.enemy_piece?(x2, y2, color)
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
    else
      false
    end
  end

  def valid_pawn_move?(pawn, previous_position, new_position)
    x, y = new_position
    dx = x - previous_position[0]
    dy = y - previous_position[1]

    if pawn.pawn_captures.include?([dx, dy])
      @board.enemy_piece?(x, y, pawn.color)
    elsif pawn.pawn_moves(previous_position).include?([dx, dy])
      @board.empty?(x, y)
    else
      false
    end
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
end
