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
  end
end
