require_relative 'piece'

class BoardSetup
  def initialize(board)
    @board = board
  end

  def initial_piece_placement
    place_pawns
    place_rooks
    place_knights
    place_bishops
    place_queens
    place_kings
  end

  private

  def place_pawns
    (0..7).each do |offset|
      @board.place_piece(Piece.for_type(:pawn, :white), [6, offset])
      @board.place_piece(Piece.for_type(:pawn, :black), [1, offset])
    end
  end

  def place_rooks
    place_pieces(:rook, [[0, 0], [0, 7], [7, 0], [7, 7]])
  end

  def place_knights
    place_pieces(:knight, [[0, 1], [0, 6], [7, 1], [7, 6]])
  end

  def place_bishops
    place_pieces(:bishop, [[0, 2], [0, 5], [7, 2], [7, 5]])
  end

  def place_queens
    place_pieces(:queen, [[0, 3], [7, 3]])
  end

  def place_kings
    place_pieces(:king, [[0, 4], [7, 4]])
  end

  def place_pieces(type, positions)
    positions.each do |pos|
      color = pos[0].zero? ? :black : :white
      @board.place_piece(Piece.for_type(type, color), pos)
    end
  end
end
