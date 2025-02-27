require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @board.setup
    @current_player = :white
  end

  def play
    puts 'Welcome to Chess!'

    @board.print_board

    puts 'White to move.'
  end
end
