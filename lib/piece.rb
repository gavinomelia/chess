class Piece
  attr_reader :type, :color, :unicode, :board

  def initialize(type, color)
    @type = type
    @color = color
    @unicode = unicode_piece(self)
  end

  def self.for_type(type, color)
    begin
      const_get(type.capitalize.to_s)
    rescue NameError
      raise ArgumentError, "Unknown piece type: #{type}"
    end.new(color)
  end

  def unicode_piece(piece)
    case piece
    when King
      piece.color == :white ? "\u265A" : "\u2654"
    when Queen
      piece.color == :white ? "\u265B" : "\u2655"
    when Rook
      piece.color == :white ? "\u265C" : "\u2656"
    when Bishop
      piece.color == :white ? "\u265D" : "\u2657"
    when Knight
      piece.color == :white ? "\u265E" : "\u2658"
    when Pawn
      piece.color == :white ? "\u265F" : "\u2659"
    else
      '?'
    end
  end
end
