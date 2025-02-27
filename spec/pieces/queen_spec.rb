require 'spec_helper'
require_relative '../../lib/pieces/queen'

RSpec.describe Queen do
  let(:board) { Board.new }
  let(:white_queen) { Queen.new(:white, board) }

  describe '#initialize' do
    it 'creates a white queen' do
      expect(white_queen.color).to eq(:white)
    end
  end

  describe '#find_moves' do
    it 'returns possible moves for a white queen' do
      board.place_piece(white_queen, [4, 4])
      expect(white_queen.find_moves([4, 4])).to contain_exactly(
        [0, 0], [1, 1], [2, 2], [3, 3],
        [5, 5], [6, 6], [7, 7],
        [1, 7], [2, 6], [3, 5],
        [5, 3], [6, 2], [7, 1],
        [0, 4], [1, 4], [2, 4], [3, 4],
        [5, 4], [6, 4], [7, 4],
        [4, 0], [4, 1], [4, 2], [4, 3],
        [4, 5], [4, 6], [4, 7]
      )
    end
    context 'when a piece is obstructing the path of the queen' do
      before do
        board.place_piece(white_queen, [0, 0])
        board.place_piece(Pawn.new(:white, board), [2, 2])
        board.place_piece(Pawn.new(:black, board), [6, 6])
      end
      it 'returns possible moves for a white queen' do
        contain_exactly(
          [1, 1],
          [5, 5],
          [6, 6],
          [1, 7], [2, 6], [3, 5],
          [5, 3], [6, 2], [7, 1],
          [0, 4], [1, 4], [2, 4], [3, 4],
          [5, 4], [6, 4], [7, 4],
          [4, 0], [4, 1], [4, 2], [4, 3],
          [4, 5], [4, 6], [4, 7]
        )
      end
    end
  end
end
