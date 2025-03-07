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
require 'YAML'

class Game
  SAVE_FILE_PATH = 'saves/saved_game.yaml'.freeze
  attr_accessor :board
  attr_reader :current_player

  def initialize
    if File.exist?(SAVE_FILE_PATH)
      load_game
    else
      start_new_game
    end
  end

  def start_new_game
    @board = Board.new
    BoardSetup.new(@board).initial_piece_placement
    @board_rules = BoardRules.new(@board)
    @current_player = :white
  end

  def play
    puts 'Welcome to Chess!'
    puts 'To exit at any time, type "exit". The game will be automatically saved.'
    puts 'To castle, type o-o for kingside or o-o-o for queenside.'
    game_loop
    puts 'Thanks for playing!'
  end

  def game_loop
    loop do
      @board.display
      input = prompt_for_input

      break if handle_exit(input)

      next unless (from, to = process_input(input))
      next unless (valid_piece = validate_piece_selection(from))
      next unless validate_move(valid_piece, to)

      execute_move(valid_piece, to)
    end
  end

  def prompt_for_input
    puts "#{@current_player.capitalize}'s turn. Enter your move (e.g., e2 e4):"
    gets.chomp
  end

  def handle_exit(input)
    return false unless input == 'exit'

    puts 'Saving and exiting the game.'
    save_game
    true
  end

  def castle(direction)
    if @board_rules.able_to_castle?(direction, @current_player)
      execute_castle(@current_player, direction)
    else
      puts "You cannot currently castle #{direction}."
    end
    false
  end

  def process_input(input)
    case input
    when 'o-o-o'
      castle(:queenside)
    when 'o-o'
      castle(:kingside)
    else
      validate_regular_input(input)
    end
  end

  def validate_regular_input(input)
    from, to = parse_input(input)
    unless from && to
      puts "Invalid input format. Please use format like 'e2 e4'."
      return nil
    end
    [from, to]
  end

  def validate_piece_selection(position)
    x, y = position
    piece = @board.grid[x][y]

    if !@board.piece_at?(x, y)
      puts 'No piece at that position.'
      return nil
    elsif piece.color != @current_player
      puts "That's not your piece."
      return nil
    end

    piece
  end

  def validate_move(piece, destination)
    unless @board_rules.legal_move?(piece, destination)
      puts 'Invalid move. Try again.'
      return false
    end
    true
  end

  def execute_castle(color, side)
    if side == :queenside
      @board.queenside_castle(color)
    elsif side == :kingside
      @board.kingside_castle(color)
    end
    switch_player
    check_game_state
  end

  def execute_move(piece, destination)
    @board.move_piece(piece, destination)
    switch_player
    check_game_state
  end

  def check_game_state
    promote_pawn
    check_for_check
    check_for_checkmate
    check_for_stalemate
  end

  def switch_player
    @current_player = @current_player == :white ? :black : :white
  end

  def check_for_check
    return unless @board_rules.in_check?(@current_player)

    puts "#{@current_player.capitalize} is in check!"
  end

  def check_for_checkmate
    return unless @board_rules.checkmate?(@current_player)

    puts 'Checkmate!'
    puts "#{other_color.capitalize} wins!"
    exit
  end

  def check_for_stalemate
    return unless @board_rules.stalemate?(@current_player)

    puts 'Stalemate!'
    puts 'The game is a draw.'
    exit
  end

  def other_color
    @current_player == :white ? :black : :white
  end

  def to_human_position(position)
    x, y = position
    x = (8 - x).to_s
    y = (y + 'a'.ord).chr
    y + x
  end

  def promote_pawn
    return unless (pawn = @board.promotable_pawn)

    puts 'Choose a piece to promote your pawn to (queen, rook, bishop, knight):'
    piece = gets.chomp.downcase
    until %w[queen rook bishop knight].include?(piece)
      puts 'Invalid piece. Choose queen, rook, bishop, or knight.'
      piece = gets.chomp.downcase
    end
    @board.promote_pawn(pawn, piece.to_sym)
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

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(SAVE_FILE_PATH, 'w') do |file|
      file.puts YAML.dump(self)
    end
  end

  def load_game
    saved_game = File.open(SAVE_FILE_PATH, 'r', &:read)
    loaded_game = YAML.unsafe_load(saved_game)
    @board = loaded_game.board
    @current_player = loaded_game.current_player
    @board_rules = BoardRules.new(@board)
  end
end
