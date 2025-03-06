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

  describe '#find_king' do
    it 'returns the position of the king' do
      board.place_piece(King.new(:white), [0, 0])
      expect(board.find_king(:white)).to be_a(King)
    end
  end

  describe '#find_rook' do
    it 'returns the position of the rook' do
      board.place_piece(Rook.new(:white), [0, 0])
      expect(board.find_rook(:white, 0)).to be_a(Rook)
    end
  end

  describe '#queenside_castle' do
    it 'moves the rook and king for a white queenside castle' do
      board.place_piece(King.new(:white), [0, 4])
      board.place_piece(Rook.new(:white), [0, 0])
      board.queenside_castle(:white)
      expect(board.grid[0][2]).to be_a(King)
      expect(board.grid[0][3]).to be_a(Rook)
    end

    it 'moves the rook and king for a black queenside castle' do
      board.place_piece(King.new(:black), [7, 4])
      board.place_piece(Rook.new(:black), [7, 0])
      board.queenside_castle(:black)
      expect(board.grid[7][2]).to be_a(King)
      expect(board.grid[7][3]).to be_a(Rook)
    end
  end

  describe '#kingside_castle' do
    it 'moves the rook and king for a white kingside castle' do
      board.place_piece(King.new(:white), [0, 4])
      board.place_piece(Rook.new(:white), [0, 7])
      board.kingside_castle(:white)
      expect(board.grid[0][6]).to be_a(King)
      expect(board.grid[0][5]).to be_a(Rook)
    end

    it 'moves the rook and king for a black kingside castle' do
      board.place_piece(King.new(:black), [7, 4])
      board.place_piece(Rook.new(:black), [7, 7])
      board.kingside_castle(:black)
      expect(board.grid[7][6]).to be_a(King)
      expect(board.grid[7][5]).to be_a(Rook)
    end
  end
end
