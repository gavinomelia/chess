require 'rspec'
require_relative '../../lib/pieces/knight'
require_relative '../../lib/board'

RSpec.describe Knight do
  let(:board) { Board.new }
  let(:knight) { Knight.new(:white, [0, 0], board) }

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

  describe '#valid_move?' do
    it 'returns true for a move within the board boundaries' do
      expect(knight.on_board?(4, 4)).to be true
    end

    it 'returns false for a move outside the board boundaries' do
      expect(knight.on_board?(8, 9)).to be false
    end
  end
end