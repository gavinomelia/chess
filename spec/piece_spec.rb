# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/piece'
require_relative '../lib/board'

RSpec.describe Piece do
  let(:board) { Board.new }
  let(:knight) { Piece.new(:knight, :white, board) }
  let(:rook) { Piece.new(:rook, :white, board) }

  before do
    board.place_piece(knight, [0, 1])
  end

  describe '#initialize' do
    context 'when it creates a piece' do
      it 'creates a piece with a color' do
        expect(knight.color).to eq(:white)
      end

      it 'creates a piece with a type' do
        expect(knight.type).to eq(:knight)
      end
    end
  end

  describe '.create_piece' do
    it 'returns a knight' do
      expect(Piece.create_piece(:knight, :white, board, [0, 1])).to be_a(Piece)
    end

    it 'places the knight on the board' do
      expect(board.grid[0][1]).to be_a(Piece)
    end

    it 'raises an error for an invalid piece type' do
      expect { Piece.create_piece(:invalid_piece, :white, board, [0, 1]) }.to raise_error(ArgumentError)
    end
  end
end
