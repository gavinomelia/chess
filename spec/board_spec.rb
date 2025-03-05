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
      board.place_piece(Piece.new(:pawn, :white), [0, 0])
      expect(board.grid[0][0]).to be_a(Piece)
    end
  end

  describe '#remove_piece' do
    it 'removes a piece from the board' do
      board.place_piece(Piece.new(:pawn, :white), [0, 0])
      board.remove_piece(0, 0)
      expect(board.grid[0][0]).to be_nil
    end
  end
end
