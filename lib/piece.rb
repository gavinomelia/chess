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
end
