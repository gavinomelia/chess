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
      place_piece(Piece.for_type(:pawn, :white), [6, i])
      place_piece(Piece.for_type(:pawn, :black), [1, i])
    end

    # Place rooks
    [[0, 0], [0, 7], [7, 0], [7, 7]].each do |pos|
      color = pos[0].zero? ? :black : :white
      place_piece(Piece.for_type(:rook, color), pos)
    end

    # Place knights
    [[0, 1], [0, 6], [7, 1], [7, 6]].each do |pos|
      color = pos[0].zero? ? :black : :white
      place_piece(Piece.for_type(:knight, color), pos)
    end

    # Place bishops
    [[0, 2], [0, 5], [7, 2], [7, 5]].each do |pos|
      color = pos[0].zero? ? :black : :white
      place_piece(Piece.for_type(:bishop, color), pos)
    end

    # Place queens
    place_piece(Piece.for_type(:queen, :black), [0, 3])
    place_piece(Piece.for_type(:queen, :white), [7, 3])

    # Place kings
    place_piece(Piece.for_type(:king, :black), [0, 4])
    place_piece(Piece.for_type(:king, :white), [7, 4])
  end

  def piece_at?(x, y)
    !@grid[x][y].nil?
  end

  def place_piece(piece, position)
    Piece.for_type(piece.type, piece.color)
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

  def move_piece(piece, new_position)
    current_position = find_piece(piece)
    return unless current_position

    x, y = current_position
    @grid[x][y] = nil
    x, y = new_position
    @grid[x][y] = piece
  end

  def enemy_piece_at?(row, col, color)
    !empty?(row, col) && !friendly_piece_at?(row, col, color)
  end

  def friendly_piece_at?(row, col, color)
    !empty?(row, col) && @grid[row][col].color == color
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
        print square.nil? ? '. ' : "#{square.unicode} "
      end
      puts "#{8 - index}"
    end
    puts '  a b c d e f g h'
  end
end
