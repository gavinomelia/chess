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
    return false if piece.is_a?(Pawn) && !valid_pawn_move?(piece, new_position)
    return false if piece.is_a?(Rook) && !valid_rook_move?(piece, new_position)

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

    # Check the final position for capture rules
    @board.empty?(x2, y2) || @board.enemy_piece?(x2, y2, color)
  end

  def filter_moves(piece, moves)
    moves.select { |move| legal_move?(piece, move) }
  end

  # PAWN MOVES
  def valid_pawn_move?(pawn, new_position)
    x, y = new_position
    previous_position = @board.find_piece(pawn)
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

  # ROOK MOVES
  def valid_rook_move?(rook, new_position)
    x, y = new_position
    previous_position = @board.find_piece(rook)
    dx = x - previous_position[0]
    dy = y - previous_position[1]

    return false if dx.zero? && dy.zero?

    # Rook moves must be in a straight line
    return false unless dx.zero? || dy.zero?

    path_clear?(previous_position, new_position, rook.color)
  end
end
