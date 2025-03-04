require 'rspec'
require_relative '../lib/board_rules'
require_relative '../lib/board'
require_relative '../lib/piece'
require_relative '../lib/pieces/pawn'

RSpec.describe BoardRules do
  let(:board) { double('board') }
  let(:piece) { double('piece') }
  let(:board_rules) { BoardRules.new(board) }

  describe '#valid_moves' do
    it 'returns only legal moves for a piece' do
      allow(board).to receive(:find_piece).with(piece).and_return([0, 0])
      allow(piece).to receive(:unvalidated_moves).and_return([[1, 2], [3, 4], [5, 6]])
      allow(board_rules).to receive(:legal_move?).with(piece, [1, 2]).and_return(true)
      allow(board_rules).to receive(:legal_move?).with(piece, [3, 4]).and_return(false)
      allow(board_rules).to receive(:legal_move?).with(piece, [5, 6]).and_return(true)

      expect(board_rules.valid_moves(piece)).to eq([[1, 2], [5, 6]])
    end
  end

  describe '#legal_move?' do
    it 'returns false if the move is off the board' do
      allow(board).to receive(:find_piece).with(piece).and_return([0, 0])
      expect(board_rules.on_board?(8, 8)).to be false

      expect(board_rules.legal_move?(piece, [8, 8])).to be false
    end

    it 'returns false if the path is not clear' do
      allow(board).to receive(:find_piece).with(piece).and_return([0, 0])
      allow(board_rules).to receive(:on_board?).with(1, 1).and_return(true)
      allow(piece).to receive(:color).and_return(:white)
      allow(board_rules).to receive(:path_clear?).with([0, 0], [1, 1], :white).and_return(false)

      expect(board_rules.legal_move?(piece, [1, 1])).to be false
    end

    it 'returns true if the move is valid' do
      allow(board).to receive(:find_piece).with(piece).and_return([0, 0])
      allow(board_rules).to receive(:on_board?).with(1, 1).and_return(true)
      allow(piece).to receive(:color).and_return(:white)
      allow(board_rules).to receive(:path_clear?).with([0, 0], [1, 1], :white).and_return(true)

      expect(board_rules.legal_move?(piece, [1, 1])).to be true
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
    let(:board) { Board.new }
    let(:board_rules) { BoardRules.new(board) }

    # TODO: Make Board Rules handle friendly obstructions

    it 'filters out invalid moves' do
      require_relative '../lib/pieces/rook'

      rook = Rook.new(:white)
      board.place_piece(rook, [0, 0])
      board.place_piece(Pawn.new(:white), [0, 1]) # Obstacle in the path

      filtered_moves = board_rules.filter_moves(rook, rook.find_moves([0, 0]))

      # Rook can move along rank but not through friendly piece
      expect(filtered_moves).to include([1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0])
      expect(filtered_moves).not_to include([0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7])
    end

    it 'filters out capturing friendly pieces' do
      require_relative '../lib/pieces/rook'

      rook = Rook.new(:white)
      board.place_piece(rook, [0, 0])
      board.place_piece(Pawn.new(:white), [1, 1]) # Friendly piece to capture

      filtered_moves = board_rules.filter_moves(rook, rook.find_moves([0, 0]))

      # Rook can move along rank but not through friendly piece
      expect(filtered_moves).not_to include([1, 1])
    end

    it 'allows capturing opponent pieces' do
      require_relative '../lib/pieces/rook'
      rook = Rook.new(:white)
      board.place_piece(rook, [0, 0])
      board.place_piece(Pawn.new(:black), [0, 1]) # Opponent piece to capture
      filtered_moves = board_rules.filter_moves(rook, rook.find_moves([0, 0]))
      expect(filtered_moves).to include([0, 1])
    end

    context 'when validating pawn moves' do
      let(:white_pawn) { Pawn.new(:white) }
      let(:black_pawn) { Pawn.new(:black) }

      before do
        board.place_piece(white_pawn, [1, 0])
        board.place_piece(black_pawn, [6, 0])
      end

      it 'returns possible moves for a white pawn' do
        expect(board_rules.filter_moves(white_pawn, white_pawn.find_moves([1, 0]))).to contain_exactly([2, 0], [3, 0])
      end

      it 'returns possible moves for a black pawn' do
        expect(board_rules.filter_moves(black_pawn, black_pawn.find_moves([6, 0]))).to contain_exactly([5, 0], [4, 0])
      end

      it 'returns capture moves for a white pawn' do
        board.place_piece(Pawn.new(:black), [2, 1])
        expect(board_rules.filter_moves(white_pawn,
                                        white_pawn.find_moves([1, 0]))).to contain_exactly([2, 0], [3, 0], [2, 1])
      end

      it 'returns capture moves for a black pawn' do
        board.place_piece(Pawn.new(:white), [5, 1])
        expect(board_rules.filter_moves(black_pawn,
                                        black_pawn.find_moves([6, 0]))).to contain_exactly([5, 0], [4, 0], [5, 1])
      end

      it 'does not return moves for a white pawn blocked by another piece' do
        board.place_piece(Pawn.new(:black), [2, 0])
        expect(board_rules.filter_moves(white_pawn, white_pawn.find_moves([1, 0]))).to be_empty
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
  end
end
