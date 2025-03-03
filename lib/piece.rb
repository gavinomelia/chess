class Piece
  attr_reader :type, :color, :board

  def initialize(type, color, board)
    @type = type
    @color = color
    @board = board
  end

  def self.for_type(type, color, board, position)
    begin
      const_get(type.capitalize.to_s)
    rescue NameError
      raise ArgumentError, "Unknown piece type: #{type}"
    end.new(color, board)
  end

  def valid_move?(new_position)
    x, y = new_position
    previous_position = @board.find_piece(self)
    return false unless Board.on_board?(x, y)
    return false unless @board.path_clear?(previous_position, new_position)

    true
  end

  def filter_moves(moves)
    moves.select { |move| valid_move?(move) }
  end
end
