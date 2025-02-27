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
end
