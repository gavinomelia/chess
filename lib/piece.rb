class Piece
  attr_reader :type, :color, :unicode, :board

  def initialize(type, color)
    @type = type
    @color = color
    @unicode = unicode_piece(self)
  end

  def self.for_type(type, color)
    class_name = type.to_s.capitalize
    begin
      const_get(class_name).new(color)
    rescue NameError
      raise ArgumentError, "Unknown piece type: #{type}"
    end
  end

  def unicode_piece(piece)
    case piece.type
    when :king
      piece.color == :white ? "\u265A" : "\u2654"
    when :queen
      piece.color == :white ? "\u265B" : "\u2655"
    when :rook
      piece.color == :white ? "\u265C" : "\u2656"
    when :bishop
      piece.color == :white ? "\u265D" : "\u2657"
    when :knight
      piece.color == :white ? "\u265E" : "\u2658"
    when :pawn
      piece.color == :white ? "\u265F" : "\u2659"
    else
      '?'
    end
  end
end
