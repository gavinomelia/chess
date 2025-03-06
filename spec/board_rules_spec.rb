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

  describe '#valid_moves' do
    it 'returns only legal moves for a piece' do
      rook = Rook.new(:white)
      board.place_piece(rook, [0, 0])
      board.place_piece(Pawn.new(:white), [0, 2])

      expected_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [0, 1]]

      expect(board_rules.valid_moves(rook)).to match_array(expected_moves)
    end
  end

  describe '#legal_move?' do
    it 'returns false if the move is off the board' do
      pawn = Pawn.new(:white)
      board.place_piece(pawn, [0, 0])

      expect(board_rules.legal_move?(pawn, [8, 8])).to be false
    end

    it 'returns false if the path is not clear' do
      bishop = Bishop.new(:white)
      board.place_piece(bishop, [0, 0])
      board.place_piece(Pawn.new(:white), [1, 1])

      expect(board_rules.legal_move?(bishop, [2, 2])).to be false
    end

    it 'returns true if the destination is on the board and the path is clear' do
      queen = Queen.new(:white)
      board.place_piece(queen, [4, 4])

      expect(board_rules.legal_move?(queen, [6, 6])).to be true
    end

    context 'when validating pawn moves' do
      it 'returns capture moves for a white pawn' do
        pawn = Pawn.new(:white)
        board.place_piece(pawn, [6, 0])
        board.place_piece(Pawn.new(:black), [5, 1])
        expect(board_rules.legal_move?(pawn, [5, 1])).to be true
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
      rook = Rook.new(:white)
      board.place_piece(rook, [0, 0])
      board.place_piece(Pawn.new(:white), [0, 1]) # Obstacle in the path

      filtered_moves = board_rules.filter_moves(rook, rook.find_moves([0, 0]))

      # Rook can move along rank but not through friendly piece
      expect(filtered_moves).to include([1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0])
      expect(filtered_moves).not_to include([0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7])
    end

    it 'filters out capturing friendly pieces' do
      rook = Rook.new(:white)
      board.place_piece(rook, [0, 0])
      board.place_piece(Pawn.new(:white), [1, 1]) # Friendly piece to capture

      filtered_moves = board_rules.filter_moves(rook, rook.find_moves([0, 0]))

      # Rook can move along rank but not through friendly piece
      expect(filtered_moves).not_to include([1, 1])
    end

    it 'allows capturing opponent pieces' do
      rook = Rook.new(:white)
      board.place_piece(rook, [0, 0])
      board.place_piece(Pawn.new(:black), [0, 1]) # Opponent piece to capture

      filtered_moves = board_rules.filter_moves(rook, rook.find_moves([0, 0]))

      expect(filtered_moves).to include([0, 1])
    end

    context 'when validating pawn moves' do
      let(:black_pawn) { Pawn.new(:black) }
      let(:white_pawn) { Pawn.new(:white) }

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
        board.place_piece(Pawn.new(:black), [2, 1])
        expect(board_rules.filter_moves(black_pawn,
                                        black_pawn.find_moves([1, 0]))).to contain_exactly([2, 0], [3, 0])
      end

      it 'does not return moves for a white pawn blocked by another piece' do
        board.place_piece(Pawn.new(:black), [2, 0])
        expect(board_rules.filter_moves(black_pawn, black_pawn.find_moves([1, 0]))).to be_empty
      end

      it 'allows a double step on first move for a white pawn' do
        # Clear the board and place a fresh black pawn
        board = Board.new
        board_rules = BoardRules.new(board)
        white_pawn = Pawn.new(:white)
        board.place_piece(white_pawn, [6, 4])

        filtered_moves = board_rules.filter_moves(white_pawn, white_pawn.find_moves([6, 4]))
        expect(filtered_moves).to include([4, 4])
      end

      xit 'returns en passant move for a white pawn' do
        board = Board.new
        board_rules = BoardRules.new(board)
        white_pawn = Pawn.new(:white)
        black_pawn = Pawn.new(:black)

        board.place_piece(white_pawn, [4, 4])
        board.place_piece(black_pawn, [4, 5])

        # Simulate black pawn just moved two squares
        board.record_double_step(black_pawn, [4, 5])

        expect(board_rules.filter_moves(white_pawn, white_pawn.find_moves([4, 4]))).to include([5, 5])
      end
    end

    context 'when validating rook moves' do
      let(:rook) { Rook.new(:white) }

      before do
        board.place_piece(rook, [4, 4])
        board.place_piece(Pawn.new(:white), [4, 6])
      end

      it 'does not include moves that go through a piece' do
        expect(board_rules.filter_moves(rook, rook.find_moves([4, 4]))).not_to include([4, 6], [4, 7])
      end
    end

    context 'when validating bishop moves' do
      let(:bishop) { Bishop.new(:white) }

      before do
        board.place_piece(bishop, [4, 4])
        board.place_piece(Pawn.new(:white), [6, 6])
      end

      it 'does not include moves that go through a piece' do
        expect(board_rules.filter_moves(bishop, bishop.find_moves([4, 4]))).not_to include([7, 7])
      end
    end
  end

  describe '#in_check?' do
    it 'returns true if the king is in check' do
      board.place_piece(King.new(:white), [0, 0])
      board.place_piece(Rook.new(:black), [0, 7])
      expect(board_rules.in_check?(:white))
        .to be true
    end

    it 'returns false if the king is not in check' do
      board.place_piece(King.new(:white), [0, 0])
      board.place_piece(Rook.new(:black), [1, 7])
      expect(board_rules.in_check?(:white))
        .to be false
    end
  end

  describe '#moves_into_check?' do
    it 'returns false if a move does not put the king in check' do
      white_king = King.new(:white)
      board.place_piece(white_king, [0, 0])
      board.place_piece(Rook.new(:black), [0, 7])
      expect(board_rules.moves_into_check?(white_king, [1, 0]))
        .to be false
    end

    it 'returns true if a move puts the king into check' do
      white_king = King.new(:white)
      board.place_piece(white_king, [0, 0])
      board.place_piece(Rook.new(:black), [1, 7])
      expect(board_rules.moves_into_check?(white_king, [1, 0]))
        .to be true
    end
  end

  describe '#checkmate?' do
    it 'returns true if the king is in checkmate' do
      board.place_piece(King.new(:white), [0, 0])
      board.place_piece(Rook.new(:black), [0, 7])
      board.place_piece(Rook.new(:black), [1, 7])
      expect(board_rules.checkmate?(:white))
        .to be true
    end
  end

  describe '#square_under_attack?' do
    it 'returns true if a square is under attack' do
      board.place_piece(Rook.new(:black), [0, 7])
      expect(board_rules.square_under_attack?(:white, [0, 0]))
        .to be true
    end

    it 'returns false if a square is not under attack' do
      board.place_piece(Rook.new(:black), [1, 7])
      expect(board_rules.square_under_attack?(:white, [0, 0]))
        .to be false
    end
  end

  describe '#able_to_castle?' do
    context 'kingside' do
      it 'returns true when conditions for kingside castling are met' do
        board = Board.new
        board_rules = BoardRules.new(board)
        king = King.new(:white)
        rook = Rook.new(:white)

        king.moved = false
        rook.moved = false

        board.place_piece(king, [7, 4]) # White king on e1
        board.place_piece(rook, [7, 7]) # White rook on h1

        expect(board_rules.able_to_castle?(:kingside, :white)).to be true
      end

      it 'returns false when king has already moved' do
        board = Board.new
        board_rules = BoardRules.new(board)
        king = King.new(:white)
        rook = Rook.new(:white)

        king.moved = true
        rook.moved = false

        board.place_piece(king, [7, 4]) # White king on e1
        board.place_piece(rook, [7, 7]) # White rook on h1

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when rook has already moved' do
        board = Board.new
        board_rules = BoardRules.new(board)
        king = King.new(:white)
        rook = Rook.new(:white)

        king.moved = false
        rook.moved = true

        board.place_piece(king, [7, 4]) # White king on e1
        board.place_piece(rook, [7, 7]) # White rook on h1

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when path between king and rook is not clear' do
        board = Board.new
        board_rules = BoardRules.new(board)
        king = King.new(:white)
        rook = Rook.new(:white)
        bishop = Bishop.new(:white)

        king.moved = false
        rook.moved = false

        board.place_piece(king, [7, 4]) # White king on e1
        board.place_piece(rook, [7, 7]) # White rook on h1
        board.place_piece(bishop, [7, 5]) # White bishop on f1 (blocking path)

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when king is in check' do
        board = Board.new
        board_rules = BoardRules.new(board)
        king = King.new(:white)
        rook = Rook.new(:white)
        enemy_rook = Rook.new(:black)

        king.moved = false
        rook.moved = false

        board.place_piece(king, [7, 4]) # White king on e1
        board.place_piece(rook, [7, 7]) # White rook on h1
        board.place_piece(enemy_rook, [0, 4]) # Black rook checking the king

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end

      it 'returns false when king moves through check' do
        board = Board.new
        board_rules = BoardRules.new(board)
        king = King.new(:white)
        rook = Rook.new(:white)
        enemy_rook = Rook.new(:black)

        king.moved = false
        rook.moved = false

        board.place_piece(king, [7, 4])
        board.place_piece(rook, [7, 7])
        board.place_piece(enemy_rook, [0, 5]) # Black rook checking the king

        expect(board_rules.able_to_castle?(:kingside, :white)).to be false
      end
    end
  end

  context 'queenside' do
    it 'returns true when conditions for queenside castling are met' do
      board = Board.new
      board_rules = BoardRules.new(board)
      king = King.new(:white)
      rook = Rook.new(:white)

      king.moved = false
      rook.moved = false

      board.place_piece(king, [7, 4])
      board.place_piece(rook, [7, 0])

      expect(board_rules.able_to_castle?(:queenside, :white))
        .to be true
    end

    it 'returns false when conditions for queenside castling are not met' do
      board = Board.new
      board_rules = BoardRules.new(board)
      king = King.new(:white)
      rook = Rook.new(:white)

      king.moved = false
      rook.moved = false

      board.place_piece(Rook.new(:black), [0, 2])
      board.place_piece(king, [7, 4])
      board.place_piece(rook, [7, 0])

      expect(board_rules.able_to_castle?(:queenside, :white))
        .to be false
    end
  end
end
