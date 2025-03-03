require 'spec_helper'
require_relative '../lib/board'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'creates a 8x8 board' do
      expect(board.grid.count).to eq(8)
    end
    it 'creates a 8x8 board with all elements initialized to nil' do
      expect(board.grid.flatten.all?(&:nil?)).to be true
    end
  end

  describe '#place_piece' do
    it 'places a piece on the board' do
      board.place_piece(Piece.new(:pawn, :white, board), [0, 0])
      expect(board.grid[0][0]).to be_a(Piece)
    end
  end

  describe '#remove_piece' do
    it 'removes a piece from the board' do
      board.place_piece(Piece.new(:pawn, :white, board), [0, 0])
      board.remove_piece(0, 0)
      expect(board.grid[0][0]).to be_nil
    end
  end

  describe '#path_clear?' do
    it 'returns false if the path is obstructed' do
      pawn = Piece.new(:pawn, :black, board)
      board.place_piece(pawn, [1, 2])
      board.place_piece(Piece.new(:pawn, :black, board), [2, 2])
      expect(board.path_clear?([0, 1], [2, 2])).to be false
    end

    it 'return true if the path is clear' do
      pawn = Piece.new(:pawn, :black, board)
      board.place_piece(pawn, [2, 2])
      expect(board.path_clear?([2, 2], [3, 2])).to be true
    end
  end

  describe '#setup' do
    before do
      board.setup
    end

    it 'places all pieces in their initial positions' do
      expect(board.grid[0][0]).to be_a(Piece)
      expect(board.grid[7][7]).to be_a(Piece)
    end

    it 'places pawns in the correct rows' do
      expect(board.grid[1].all? { |piece| piece.is_a?(Piece) && piece.type == :pawn }).to be true
      expect(board.grid[6].all? { |piece| piece.is_a?(Piece) && piece.type == :pawn }).to be true
    end

    it 'places rooks in the correct positions' do
      expect(board.grid[0][0].type).to eq(:rook)
      expect(board.grid[0][7].type).to eq(:rook)
      expect(board.grid[7][0].type).to eq(:rook)
      expect(board.grid[7][7].type).to eq(:rook)
    end

    it 'places knights in the correct positions' do
      expect(board.grid[0][1].type).to eq(:knight)
      expect(board.grid[0][6].type).to eq(:knight)
      expect(board.grid[7][1].type).to eq(:knight)
      expect(board.grid[7][6].type).to eq(:knight)
    end

    it 'places bishops in the correct positions' do
      expect(board.grid[0][2].type).to eq(:bishop)
      expect(board.grid[0][5].type).to eq(:bishop)
      expect(board.grid[7][2].type).to eq(:bishop)
      expect(board.grid[7][5].type).to eq(:bishop)
    end

    it 'places queens in the correct positions' do
      expect(board.grid[0][3].type).to eq(:queen)
      expect(board.grid[7][3].type).to eq(:queen)
    end

    it 'places kings in the correct positions' do
      expect(board.grid[0][4].type).to eq(:king)
      expect(board.grid[7][4].type).to eq(:king)
    end
  end
end
