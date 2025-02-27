require 'spec_helper'
require_relative '../../lib/pieces/rook'
require_relative '../../lib/board'

RSpec.describe Rook do
  let(:board) { Board.new }
  let(:white_rook) { Rook.new(:white, board) }
  let(:black_rook) { Rook.new(:black, board) }

  describe '#initialize' do
    it 'creates a white rook' do
      expect(white_rook.color).to eq(:white)
    end

    it 'creates a black king' do
      expect(black_rook.color).to eq(:black)
    end
  end

  describe '#find_moves' do
    context 'when rook is in the center of the board' do
      before do
        board.place_piece(white_rook, [4, 4])
      end

      it 'returns possible moves for a white rook' do
        expect(white_rook.find_moves([4, 4])).to contain_exactly(
          [0, 4], [1, 4], [2, 4], [3, 4], [5, 4], [6, 4], [7, 4], # X axis
          [4, 0], [4, 1], [4, 2], [4, 3], [4, 5], [4, 6], [4, 7] # Y axis
        )
      end
    end

    context 'when a piece is obstructing the path of the rook' do
      before do
        board.place_piece(white_rook, [4, 4])
        board.place_piece(Pawn.new(:white, board), [4, 6])
        board.print_board
      end

      it 'returns possible moves for a white rook' do
        contain_exactly(
          [0, 4], [1, 4], [2, 4], [3, 4],
          [4, 0], [4, 1], [4, 2], [4, 3], [4, 5],
          [5, 4], [6, 4], [7, 4]
        )
      end
    end
  end
end
