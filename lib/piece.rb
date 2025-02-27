require_relative 'board'

class Piece
  attr_reader :type, :color, :board

  def initialize(type, color, board)
    @type = type
    @color = color
    @board = board
  end

  def self.create_piece(type, color, board, position)
    piece_class = {
      pawn: Pawn,
      rook: Rook,
      knight: Knight,
      bishop: Bishop,
      queen: Queen,
      king: King
    }
    raise ArgumentError, "Unknown piece type: #{type}" unless piece_class.key?(type)

    piece = piece_class[type].new(color, board)
    board.place_piece(piece, position)
    piece
  end

  def move(new_position)
    @board.move_piece(self, new_position)
  end

  def on_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def valid_move?(new_position)
    x, y = new_position
    previous_position = @board.find_piece(self)
    return false unless on_board?(x, y)
    return false unless @board.path_clear?(previous_position, new_position)

    true
  end

  def filter_moves(moves)
    moves.select { |move| valid_move?(move) }
  end
end
