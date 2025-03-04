require 'spec_helper'
require_relative '../../lib/pieces/bishop'
require_relative '../../lib/board'

RSpec.describe Bishop do
  let(:board) { Board.new }
  let(:white_bishop) { Bishop.new(:white) }

  describe '#initialize' do
    it 'creates a white bishop' do
      expect(white_bishop.color).to eq(:white)
    end
  end

  describe '#find_moves' do
    it 'returns possible moves for a white bishop' do
      board.place_piece(white_bishop, [4, 4])
      expect(white_bishop.find_moves([4, 4])).to contain_exactly(
        [0, 0], [1, 1], [2, 2], [3, 3],
        [5, 5], [6, 6], [7, 7],
        [1, 7], [2, 6], [3, 5],
        [5, 3], [6, 2], [7, 1]
      )
    end

    # This test is commented out because the Bishop class does not currently handle obstructions.
    # This will be the responsibility of the board rules class.

    # context 'when a piece is obstructing the path of the bishop' do
    #   before do
    #     board.place_piece(white_bishop, [4, 4])
    #     board.place_piece(Pawn.new(:white, board), [2, 2])
    #     board.place_piece(Pawn.new(:black, board), [6, 6])
    #   end

    #   it 'returns possible moves for a white bishop' do
    #     expect(white_bishop.find_moves([4, 4])).to contain_exactly(
    #       [3, 3], [5, 5], [2, 2],
    #       [1, 7], [2, 6], [3, 5],
    #       [5, 3], [6, 2], [7, 1],
    #       [6, 6]
    #     )
    #   end
    # end
  end
end
