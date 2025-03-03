class BoardRules
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
    return false unless path_clear?(previous_position, new_position)

    true
  end

  # TODO: There's another on_board on the board class.
  def on_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def path_clear?(start_pos, end_pos)
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

    true
  end

  def filter_moves(piece, moves)
    moves.select { |move| legal_move?(piece, move) }
  end
end
