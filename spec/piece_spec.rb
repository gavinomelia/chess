# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/piece'
require_relative '../lib/board'

RSpec.describe Piece do
  let(:board) { Board.new }
  let(:pawn) { Piece.new(:pawn, :white) }

  before do
    board.place_piece(pawn, [0, 1])
  end

  describe '#initialize' do
    context 'when it creates a piece' do
      it 'creates a piece with a color' do
        expect(pawn.color).to eq(:white)
      end

      it 'creates a piece with a type' do
        expect(pawn.type).to eq(:pawn)
      end
    end
  end

  describe '.create_piece' do
    it 'returns a pawn' do
      expect(Piece.for_type(:pawn, :white)).to be_a(Piece)
    end

    it 'raises an error for an invalid piece type' do
      expect { Piece.for_type(:invalid_piece, :white, board, [0, 1]) }.to raise_error(ArgumentError)
    end
  end
end
