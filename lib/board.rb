class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
  end

  def piece_at?(x, y)
    !@board[x][y].nil?
  end

  def place_piece(piece, position)
    x, y = position
    @board[x][y] = piece
  end

  def remove_piece(x, y)
    @board[x][y] = nil
  end

  def empty?(x, y)
    @board[x][y].nil?
  end

  def move_piece(piece, new_position)
    current_position = find_piece(piece)
    return unless current_position

    x, y = current_position
    @board[x][y] = nil
    x, y = new_position
    @board[x][y] = piece
  end

  def enemy_piece?(x, y, color)
    !empty?(x, y) && @board[x][y].color != color
  end

  def find_piece(piece)
    @board.each_with_index do |row, x|
      y = row.find_index(piece)
      return [x, y] if y
    end
    nil
  end

  def obstructions(piece, new_position)
  end

  def print_board
    @board.each do |row|
      puts row.map { |cell| cell.nil? ? '.' : cell.type[0].upcase }.join(' ')
    end
  end
end
