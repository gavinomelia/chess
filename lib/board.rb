require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
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

  def find_piece(piece)
    @grid.each_with_index do |row, x|
      y = row.find_index(piece)
      return [x, y] if y
    end
    nil
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
