require_relative 'piece'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
  end

  def setup
    # Place pawns
    (0..7).each do |i|
      place_piece(Piece.for_type(:pawn, 'white', self, [6, i]), [6, i])
      place_piece(Piece.for_type(:pawn, 'black', self, [1, i]), [1, i])
    end

    # Place rooks
    [[0, 0], [0, 7], [7, 0], [7, 7]].each do |pos|
      color = pos[0].zero? ? 'black' : 'white'
      place_piece(Piece.for_type(:rook, color, self, pos), pos)
    end

    # Place knights
    [[0, 1], [0, 6], [7, 1], [7, 6]].each do |pos|
      color = pos[0].zero? ? 'black' : 'white'
      place_piece(Piece.for_type(:knight, color, self, pos), pos)
    end

    # Place bishops
    [[0, 2], [0, 5], [7, 2], [7, 5]].each do |pos|
      color = pos[0].zero? ? 'black' : 'white'
      place_piece(Piece.for_type(:bishop, color, self, pos), pos)
    end

    # Place queens
    place_piece(Piece.for_type(:queen, 'black', self, [0, 3]), [0, 3])
    place_piece(Piece.for_type(:queen, 'white', self, [7, 3]), [7, 3])

    # Place kings
    place_piece(Piece.for_type(:king, 'black', self, [0, 4]), [0, 4])
    place_piece(Piece.for_type(:king, 'white', self, [7, 4]), [7, 4])
  end

  def piece_at?(x, y)
    !@grid[x][y].nil?
  end

  def place_piece(piece, position)
    Piece.for_type(piece.type, piece.color, self, position)
    x, y = position
    @grid[x][y] = piece
  end

  def remove_piece(x, y)
    @grid[x][y] = nil
  end

  def empty?(x, y)
    @grid[x][y].nil?
  end

  def self.on_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def path_clear?(start_pos, end_pos)
    start_x, start_y = start_pos
    x2, y2 = end_pos

    x_step = x2 <=> start_x
    y_step = y2 <=> start_y

    current_x = start_x + x_step
    current_y = start_y + y_step

    while [current_x, current_y] != [x2, y2]
      return false unless empty?(current_x, current_y)

      current_x += x_step
      current_y += y_step
    end

    true
  end

  def move_piece(piece, new_position)
    current_position = find_piece(piece)
    return unless current_position

    x, y = current_position
    @grid[x][y] = nil
    x, y = new_position
    @grid[x][y] = piece
  end

  def enemy_piece?(x, y, color)
    !empty?(x, y) && @grid[x][y].color != color
  end

  def find_piece(piece)
    @grid.each_with_index do |row, x|
      y = row.find_index(piece)
      return [x, y] if y
    end
    nil
  end

  def print_debug_board
    puts "\n"
    puts '  0 1 2 3 4 5 6 7'
    @grid.each_with_index do |row, index|
      print "#{index} "
      row.each do |square|
        print square.nil? ? '. ' : "#{square.class.to_s[0].upcase} "
      end
      puts "#{index}"
    end
    puts '  0 1 2 3 4 5 6 7'
  end

  def print_board
    puts "\n"
    puts '  a b c d e f g h'
    @grid.each_with_index do |row, index|
      print "#{8 - index} "
      row.each do |square|
        print square.nil? ? '. ' : "#{unicode_piece(square)} "
      end
      puts "#{8 - index}"
    end
    puts '  a b c d e f g h'
  end

  private

  def unicode_piece(piece)
    case piece
    when King
      piece.color == 'white' ? "\u2654" : "\u265A"
    when Queen
      piece.color == 'white' ? "\u2655" : "\u265B"
    when Rook
      piece.color == 'white' ? "\u2656" : "\u265C"
    when Bishop
      piece.color == 'white' ? "\u2657" : "\u265D"
    when Knight
      piece.color == 'white' ? "\u2658" : "\u265E"
    when Pawn
      piece.color == 'white' ? "\u2659" : "\u265F"
    else
      '?'
    end
  end
end
