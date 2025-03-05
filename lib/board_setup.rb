require_relative 'piece'

class BoardSetup
  def initialize(board)
    @board = board
  end

  def initial_piece_placement
    # Place pawns
    (0..7).each do |i|
      @board.place_piece(Piece.for_type(:pawn, :white), [6, i])
      @board.place_piece(Piece.for_type(:pawn, :black), [1, i])
    end

    # Place rooks
    [[0, 0], [0, 7], [7, 0], [7, 7]].each do |pos|
      color = pos[0].zero? ? :black : :white
      @board.place_piece(Piece.for_type(:rook, color), pos)
    end

    # Place knights
    [[0, 1], [0, 6], [7, 1], [7, 6]].each do |pos|
      color = pos[0].zero? ? :black : :white
      @board.place_piece(Piece.for_type(:knight, color), pos)
    end

    # Place bishops
    [[0, 2], [0, 5], [7, 2], [7, 5]].each do |pos|
      color = pos[0].zero? ? :black : :white
      @board.place_piece(Piece.for_type(:bishop, color), pos)
    end

    # Place queens
    @board.place_piece(Piece.for_type(:queen, :black), [0, 3])
    @board.place_piece(Piece.for_type(:queen, :white), [7, 3])

    # Place kings
    @board.place_piece(Piece.for_type(:king, :black), [0, 4])
    @board.place_piece(Piece.for_type(:king, :white), [7, 4])
  end
end
