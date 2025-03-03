require 'spec_helper'
require_relative '../../lib/pieces/knight'
require_relative '../../lib/board'

RSpec.describe Knight do
  let(:board) { Board.new }
  let(:knight) { Knight.new(:white, board) }

  before do
    board.place_piece(knight, [0, 0])
  end

  describe '#find_knight_moves' do
    it 'returns all valid knight moves from a given position' do
      start_position = [4, 4]
      expected_moves = [
        [6, 5], [6, 3], [2, 5], [2, 3],
        [5, 6], [5, 2], [3, 6], [3, 2]
      ]
      expect(knight.find_moves(start_position)).to match_array(expected_moves)
    end

    it 'filters out moves that are off the board' do
      start_position = [0, 0]
      expected_moves = [[2, 1], [1, 2]]
      expect(knight.find_moves(start_position)).to match_array(expected_moves)
    end
  end

  describe '#possible_moves' do
    it 'returns valid moves for a given position' do
      position = [3, 3]
      expected_moves = [
        [5, 4], [5, 2], [1, 4], [1, 2],
        [4, 5], [4, 1], [2, 5], [2, 1]
      ]
      expect(knight.possible_moves(position)).to match_array(expected_moves)
    end
  end
end
