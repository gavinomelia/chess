require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
  end

  def piece_at?(x, y)
    !@grid[x][y].nil?
  end

  def place_piece(piece, position)
    Piece.for_type(piece.type, piece.color)
    x, y = position
    @grid[x][y] = piece
  end

  def remove_piece(x, y)
    @grid[x][y] = nil
  end

  def empty?(x, y)
    return unless Board.on_board?(x, y)

    @grid[x][y].nil?
  end

  def self.on_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def move_piece(piece, new_position)
    current_position = find_piece(piece)
    return unless current_position

    piece.moved = true if piece.is_a?(King) || piece.is_a?(Rook)

    x, y = current_position
    @grid[x][y] = nil
    x, y = new_position
    @grid[x][y] = piece
  end

  def find_piece(piece)
    @grid.each_with_index do |row, x|
      y = row.find_index(piece)
      return [x, y] if y
    end
    nil
  end

  def find_king(color)
    @grid.flatten.find { |piece| piece.is_a?(King) && piece.color == color }
  end

  def find_rook(color, y)
    @grid.flatten.find { |piece| piece.is_a?(Rook) && piece.color == color && find_piece(piece)[1] == y }
  end

  def queenside_castle(color)
    perform_castle(color, 0, -2, +3)
  end

  def kingside_castle(color)
    perform_castle(color, 7, +2, -2)
  end

  def perform_castle(color, rook_column, king_move, rook_move)
    king = find_king(color)
    king_position = find_piece(king)
    rook = find_rook(color, rook_column)
    rook_position = find_piece(rook)

    move_piece(king, [king_position[0], king_position[1] + king_move])
    move_piece(rook, [rook_position[0], rook_position[1] + rook_move])
  end

  def enemy_piece_at?(row, col, color)
    piece = @grid[row][col]
    piece && piece.color != color
  end

  def friendly_piece_at?(row, col, color)
    piece = @grid[row][col]
    piece && piece.color == color
  end

  def temporarily_move_piece(old_position, new_position)
    # Save the current state of the board.
    original_piece = @grid[old_position[0]][old_position[1]]
    original_target = @grid[new_position[0]][new_position[1]]

    # Move the piece temporarily.
    @grid[new_position[0]][new_position[1]] = original_piece
    @grid[old_position[0]][old_position[1]] = nil

    # Yield the block and capture its result
    result = yield

    # Restore the board state.
    @grid[old_position[0]][old_position[1]] = original_piece
    @grid[new_position[0]][new_position[1]] = original_target

    # Return the result from the block
    result
  end

  def pieces_of_opposite_color(color)
    @grid.flatten.compact.select { |piece| piece.color != color }
  end

  def pieces_of_color(color)
    @grid.flatten.compact.select { |piece| piece.color == color }
  end

  def promote_pawn(piece, desired_piece)
    x, y = find_piece(piece)
    piece = Piece.for_type(desired_piece, piece.color)
    @grid[x][y] = piece
  end

  def display_debug
    puts "\n"
    puts '  0 1 2 3 4 5 6 7'
    @grid.each_with_index do |row, index|
      print "#{index} "
      row.each do |square|
        print square.nil? ? '. ' : "#{square.unicode} "
      end
      puts index
    end
    puts '  0 1 2 3 4 5 6 7'
  end

  def display
    puts "\n"
    puts '  a b c d e f g h'
    @grid.each_with_index do |row, index|
      print "#{8 - index} "
      row.each do |square|
        print square.nil? ? '. ' : "#{square.unicode} "
      end
      puts 8 - index
    end
    puts '  a b c d e f g h'
  end
end
