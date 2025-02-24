class Board
  attr_accessor :board

  def initialize
    @board = Array.new(9) { Array.new(9, 0) }
  end
end