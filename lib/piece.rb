class Piece
  attr_reader :type, :color, :board

  def initialize(type, color)
    @type = type
    @color = color
  end

  def self.for_type(type, color)
    begin
      const_get(type.capitalize.to_s)
    rescue NameError
      raise ArgumentError, "Unknown piece type: #{type}"
    end.new(color)
  end
end
