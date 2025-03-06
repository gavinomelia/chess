require_relative 'board'
require_relative 'board_setup'
require_relative 'board_rules'
require_relative 'piece'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'

class Game
  def initialize
    @board = Board.new
    BoardSetup.new(@board).initial_piece_placement
    @board_rules = BoardRules.new(@board)
    @current_player = :white
  end

  def switch_player
    @current_player = @current_player == :white ? :black : :white
  end

  def play
    puts 'Welcome to Chess!'

    loop do
      @board.print_board
      input = prompt_for_input

      if input == 'exit'
        puts 'Exiting the game.'
        break
      end

      from, to = parse_input(input)
      if from.nil? || to.nil?
        puts "Invalid input format. Please use format like 'e2 e4'."
        next
      end

      x, y = from
      unless @board.piece_at?(x, y)
        puts 'No piece at that position.'
        next
      end

      piece = @board.grid[x][y]
      if piece.color != @current_player
        puts "That's not your piece."
        next
      end

      unless @board_rules.legal_move?(piece, to)
        puts 'Invalid move. Try again.'
        next
      end

      @board.move_piece(piece, to)
      switch_player
      puts 'Move successful!'
    end
    puts 'Thanks for playing!'
  end

  def prompt_for_input
    puts "#{@current_player.capitalize}'s turn. Enter your move (e.g., e2 e4):"
    gets.chomp
  end

  def to_human_position(position)
    x, y = position
    x = (8 - x).to_s
    y = (y + 'a'.ord).chr
    y + x
  end

  private

  def parse_position(move)
    return nil unless move && move.length == 2
    return nil unless ('a'..'h').include?(move[0].downcase) && ('1'..'8').include?(move[1])

    x = 8 - move[1].to_i
    y = move[0].downcase.ord - 'a'.ord
    [x, y]
  end

  def parse_input(input)
    from_str, to_str = input.split
    from = parse_position(from_str)
    to = parse_position(to_str)
    [from, to]
  end
end
