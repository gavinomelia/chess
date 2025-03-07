require 'rspec'
require_relative '../lib/board_rules'
require_relative '../lib/board'
require_relative '../lib/piece'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'

RSpec.describe BoardRules do
  let(:board) { Board.new }
  let(:board_rules) { BoardRules.new(board) }
  let(:white_rook) { Rook.new(:white) }
  let(:white_king) { King.new(:white) }
  let(:black_king) { King.new(:black) }
  let(:white_rook) { Rook.new(:white) }
  let(:black_rook) { Rook.new(:black) }
  let(:white_pawn) { Pawn.new(:white) }
  let(:black_pawn) { Pawn.new(:black) }
  let(:white_bishop) { Bishop.new(:white) }

  describe '#valid_moves' do
    it 'returns only legal moves for a piece' do
      board.place_piece(white_rook, [0, 0])
      board.place_piece(white_pawn, [0, 2])

      expected_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [0, 1]]

      expect(board_rules.valid_moves(white_rook)).to match_array(expected_moves)
    end
  end

  describe '#legal_move?' do
    it 'returns false if the move is off the board' do
      board.place_piece(white_pawn, [0, 0])

      expect(board_rules.legal_move?(white_pawn, [8, 8])).to be false
    end

    it 'returns false if the path is not clear' do
      board.place_piece(white_bishop, [0, 0])
      board.place_piece(white_pawn, [1, 1])

      expect(board_rules.legal_move?(white_bishop, [2, 2])).to be false
    end

    it 'returns true if the destination is on the board and the path is clear' do
      queen = Queen.new(:white)
      board.place_piece(queen, [4, 4])

      expect(board_rules.legal_move?(queen, [6, 6])).to be true
    end

    context 'when validating pawn moves' do
      it 'returns capture moves for a white pawn' do
        board.place_piece(white_pawn, [6, 0])
        board.place_piece(black_pawn, [5, 1])
        expect(board_rules.legal_move?(white_pawn, [5, 1])).to be true
      end
    end
  end

  describe '#path_clear?' do
    it 'returns false if there is an obstacle in the path' do
      allow(board).to receive(:empty?).with(1, 1).and_return(false)

      expect(board_rules.path_clear?([0, 0], [2, 2], :white)).to be false
    end

    it 'returns true if the path is clear' do
      allow(board).to receive(:empty?).with(1, 1).and_return(true)
      allow(board).to receive(:empty?).with(2, 2).and_return(true)

      expect(board_rules.path_clear?([0, 0], [2, 2], :white)).to be true
    end
  end

  describe '#filter_moves' do
    it 'filters out invalid moves' do
      board.place_piece(white_rook, [0, 0])
      board.place_piece(white_pawn, [0, 1]) # Obstacle in the path

      filtered_moves = board_rules.filter_moves(white_rook, white_rook.find_moves([0, 0]))

      # Rook can move along rank but not through friendly piece
      expect(filtered_moves).to include([1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0])
      expect(filtered_moves).not_to include([0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7])
    end

    it 'filters out capturing friendly pieces' do
      board.place_piece(white_rook, [0, 0])
      board.place_piece(white_pawn, [1, 1]) # Friendly piece to capture

      filtered_moves = board_rules.filter_moves(white_rook, white_rook.find_moves([0, 0]))

      # Rook can move along rank but not through friendly piece
      expect(filtered_moves).not_to include([1, 1])
    end

    it 'allows capturing opponent pieces' do
      board.place_piece(white_rook, [0, 0])
      board.place_piece(black_pawn, [0, 1]) # Opponent piece to capture

      filtered_moves = board_rules.filter_moves(white_rook, white_rook.find_moves([0, 0]))

      expect(filtered_moves).to include([0, 1])
    end

    context 'when validating pawn moves' do
      before do
        board.place_piece(black_pawn, [1, 0])
        board.place_piece(white_pawn, [6, 0])
      end

      it 'returns possible moves for a black pawn' do
        expect(board_rules.filter_moves(black_pawn, black_pawn.find_moves([1, 0]))).to contain_exactly([2, 0], [3, 0])
      end

      it 'returns possible moves for a white pawn' do
        expect(board_rules.filter_moves(white_pawn, white_pawn.find_moves([6, 0]))).to contain_exactly([5, 0], [4, 0])
      end

      it 'returns capture moves for a black pawn' do
        board.place_piece(black_pawn, [2, 1])
        expect(board_rules.filter_moves(black_pawn,
                                        black_pawn.find_moves([1, 0]))).to contain_exactly([2, 0], [3, 0])
      end

      it 'does not return moves for a white pawn blocked by another piece' do
        board.place_piece(black_pawn, [2, 0])
        expect(board_rules.filter_moves(black_pawn, black_pawn.find_moves([1, 0]))).to be_empty
      end

      it 'allows a double step on first move for a white pawn' do
        filtered_moves = board_rules.filter_moves(white_pawn, white_pawn.find_moves([6, 0]))
        expect(filtered_moves).to include([4, 0])
      end
    end

    context 'when validating rook moves' do
      before do
        board.place_piece(white_rook, [4, 4])
        board.place_piece(white_pawn, [4, 6])
      end

      it 'does not include moves that go through a piece' do
        expect(board_rules.filter_moves(white_rook, white_rook.find_moves([4, 4]))).not_to include([4, 6], [4, 7])
      end
    end

    context 'when validating bishop moves' do
      before do
        board.place_piece(white_bishop, [4, 4])
        board.place_piece(white_pawn, [6, 6])
      end

      it 'does not include moves that go through a piece' do
        expect(board_rules.filter_moves(white_bishop, white_bishop.find_moves([4, 4]))).not_to include([7, 7])
      end
    end
  end

  describe '#in_check?' do
    it 'returns true if the king is in check' do
      board.place_piece(white_king, [0, 0])
      board.place_piece(black_rook, [0, 7])
      expect(board_rules.in_check?(:white))
        .to be true
    end

    it 'returns false if the king is not in check' do
      board.place_piece(white_king, [0, 0])
      board.place_piece(black_rook, [1, 7])
      expect(board_rules.in_check?(:white))
        .to be false
    end
  end

  describe '#moves_into_check?' do
    it 'returns false if a move does not put the king in check' do
      board.place_piece(white_king, [0, 0])
      board.place_piece(black_rook, [0, 7])
      expect(board_rules.moves_into_check?(white_king, [1, 0]))
        .to be false
    end

    it 'returns true if a move puts the king into check' do
      board.place_piece(white_king, [0, 0])
      board.place_piece(black_rook, [1, 7])
      expect(board_rules.moves_into_check?(white_king, [1, 0]))
        .to be true
    end
  end

  describe '#checkmate?' do
    it 'returns true if the king is in checkmate' do
      board.place_piece(white_king, [0, 0])
      board.place_piece(black_rook, [0, 7])
      board.place_piece(Rook.new(:black), [1, 7])
      expect(board_rules.checkmate?(:white))
        .to be true
    end
  end

  describe '#square_under_attack?' do
    it 'returns true if a square is under attack' do
      board.place_piece(black_rook, [0, 7])
      expect(board_rules.square_under_attack?(:white, [0, 0]))
        .to be true
    end

    it 'returns false if a square is not under attack' do
      board.place_piece(black_rook, [1, 7])
      expect(board_rules.square_under_attack?(:white, [0, 0]))
        .to be false
    end
  end

  describe '#able_to_castle?' do
    context 'kingside' do
      it 'returns true when conditions for kingside castling are met' do
        white_king.moved = false
        white_rook.moved = false

        board.place_piece(white_king, [7, 4]) # White king on e1
        board.place_piece(white_rook, [7, 7]) # White rook on h1

        expect(board_rules.able_to_castle?(:kingside, :white)).to be true
      end

      it 'returns false when king has already moved' do
        white_king.moved = true
        white_rook.moved = false
        board.place_piece(white_king, [7, 4]) # White king on e1
        board.place_piece(white_rook, [7, 7]) # White rook on h1

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when rook has already moved' do
        white_king.moved = false
        white_rook.moved = true

        board.place_piece(white_king, [7, 4]) # White king on e1
        board.place_piece(white_rook, [7, 7]) # White rook on h1

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when path between king and rook is not clear' do
        white_king.moved = false
        white_rook.moved = false

        board.place_piece(white_king, [7, 4]) # White king on e1
        board.place_piece(white_rook, [7, 7]) # White rook on h1
        board.place_piece(white_bishop, [7, 5]) # White bishop on f1 (blocking path)

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when king is in check' do
        white_king.moved = false
        white_rook.moved = false

        board.place_piece(white_king, [7, 4]) # White king on e1
        board.place_piece(white_rook, [7, 7]) # White rook on h1
        board.place_piece(black_rook, [0, 4]) # Black rook checking the king

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when king moves through check' do
        white_king.moved = false
        white_rook.moved = false

        board.place_piece(white_king, [7, 4])
        board.place_piece(white_rook, [7, 7])
        board.place_piece(black_rook, [0, 5]) # Black rook checking the king

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end
    end
  end

  context 'queenside' do
    it 'returns true when conditions for queenside castling are met' do
      white_king.moved = false
      white_rook.moved = false

      board.place_piece(white_king, [7, 4])
      board.place_piece(white_rook, [7, 0])

      expect(board_rules.able_to_castle?(:queenside, :white))
        .to be true
    end

    it 'returns false when conditions for queenside castling are not met' do
      white_king.moved = false
      white_rook.moved = false

      board.place_piece(black_rook, [0, 2])
      board.place_piece(white_king, [7, 4])
      board.place_piece(white_rook, [7, 0])

      expect(board_rules.able_to_castle?(:queenside, :white))
        .to be false
    end
  end

  describe '#stalemate?' do
    it 'returns true if the game is a stalemate' do
      board.place_piece(white_king, [0, 0])
      board.place_piece(black_rook, [1, 1])
      board.place_piece(black_rook, [1, 2])
      expect(board_rules.stalemate?(:white))
        .to be true
    end

    it 'returns false if the game is not a stalemate' do
      board.place_piece(white_king, [0, 0])
      board.place_piece(black_king, [7, 7])
      expect(board_rules.stalemate?(:white))
        .to be false
    end
  end

  describe '#valid_en_passant?' do
    context 'white pieces' do
      it 'returns true if en passant is valid' do
        board.place_piece(white_pawn, [3, 5])
        board.place_piece(black_pawn, [1, 4])

        board.move_piece(black_pawn, [3, 4])

        expect(board_rules.valid_en_passant?(white_pawn))
          .to be true
      end

      it 'returns false if en passant is not valid' do
        board.place_piece(white_pawn, [2, 5])
        board.place_piece(black_pawn, [1, 4])

        board.move_piece(black_pawn, [2, 4])

        expect(board_rules.valid_en_passant?(white_pawn))
          .to be false
      end
    end

    context 'black pieces' do
      it 'returns true if en passant is valid' do
        board.place_piece(white_pawn, [6, 5])
        board.place_piece(black_pawn, [4, 4])

        board.move_piece(white_pawn, [4, 5])

        expect(board_rules.valid_en_passant?(black_pawn))
          .to be true
      end
    end
  end
end
