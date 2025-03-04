require 'spec_helper'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/board'

RSpec.describe Pawn do
  let(:board) { Board.new }
  let(:white_pawn) { Pawn.new(:white) }
  let(:black_pawn) { Pawn.new(:black) }

  describe '#initialize' do
    it 'creates a white pawn' do
      expect(white_pawn.color).to eq(:white)
    end

    it 'creates a black pawn' do
      expect(black_pawn.color).to eq(:black)
    end
  end

  describe '#find_moves' do
    context 'when pawns are on their starting positions' do
      before do
        board.place_piece(white_pawn, [1, 0])
        board.place_piece(black_pawn, [6, 0])
      end

      it 'returns possible moves for a white pawn' do
        expect(white_pawn.find_moves([1, 0])).to contain_exactly([2, 0], [3, 0], [2, 1])
      end

      it 'returns possible moves for a black pawn' do
        expect(black_pawn.find_moves([6, 0])).to contain_exactly([5, 0], [4, 0], [5, 1])
      end
    end

    context 'when pawns are not on their starting positions' do
      before do
        board.place_piece(white_pawn, [2, 0])
        board.place_piece(black_pawn, [5, 0])
      end

      it 'returns all possible moves for a white pawn' do
        expect(white_pawn.find_moves([2, 0])).to contain_exactly([3, 0], [3, 1])
      end

      it 'returns all possible moves for a black pawn' do
        expect(black_pawn.find_moves([5, 0])).to contain_exactly([4, 0], [4, 1])
      end
    end
  end
end
