require 'spec_helper'
require_relative '../../lib/pieces/king'
require_relative '../../lib/board'

RSpec.describe King do
  let(:board) { Board.new }
  let(:white_king) { King.new(:white, board) }
  let(:black_king) { King.new(:black, board) }

  describe '#initialize' do
    it 'creates a white king' do
      expect(white_king.color).to eq(:white)
    end

    it 'creates a black king' do
      expect(black_king.color).to eq(:black)
    end
  end

  describe '#find_moves' do
    context 'when king is in the center of the board' do
      before do
        board.place_piece(white_king, [4, 4])
        board.place_piece(black_king, [5, 5])
      end

      it 'returns possible moves for a white king' do
        expect(white_king.find_moves([4, 4])).to contain_exactly(
          [3, 3], [3, 4], [3, 5],
          [4, 3],         [4, 5],
          [5, 3], [5, 4], [5, 5]
        )
      end

      it 'returns possible moves for a black king' do
        expect(black_king.find_moves([5, 5])).to contain_exactly(
          [4, 4], [4, 5], [4, 6],
          [5, 4],         [5, 6],
          [6, 4], [6, 5], [6, 6]
        )
      end
    end

    context 'when king is on the edge of the board' do
      before do
        board.place_piece(white_king, [0, 0])
        board.place_piece(black_king, [7, 7])
      end

      it 'returns possible moves for a white king' do
        expect(white_king.find_moves([0, 0])).to contain_exactly(
          [0, 1],
          [1, 0], [1, 1]
        )
      end
    end
  end
end
