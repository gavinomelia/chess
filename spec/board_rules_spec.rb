require 'rspec'
require_relative '../lib/board_rules'
require_relative '../lib/piece'

RSpec.describe BoardRules do
  let(:board) { double('board') }
  let(:piece) { double('piece') }
  let(:board_rules) { BoardRules.new(board) }

  describe '#valid_moves' do
    it 'returns only legal moves for a piece' do
      allow(piece).to receive(:unvalidated_moves).and_return([[1, 2], [3, 4], [5, 6]])
      allow(board_rules).to receive(:legal_move?).with(piece, [1, 2]).and_return(true)
      allow(board_rules).to receive(:legal_move?).with(piece, [3, 4]).and_return(false)
      allow(board_rules).to receive(:legal_move?).with(piece, [5, 6]).and_return(true)

      expect(board_rules.valid_moves(piece)).to eq([[1, 2], [5, 6]])
    end
  end

  describe '#legal_move?' do
    it 'returns false if the move is off the board' do
      allow(board).to receive(:find_piece).with(piece).and_return([0, 0])
      expect(board_rules.on_board?(8, 8)).to be false

      expect(board_rules.legal_move?(piece, [8, 8])).to be false
    end

    it 'returns false if the path is not clear' do
      allow(board).to receive(:find_piece).with(piece).and_return([0, 0])
      allow(board_rules).to receive(:on_board?).with(1, 1).and_return(true)
      allow(board_rules).to receive(:path_clear?).with([0, 0], [1, 1]).and_return(false)

      expect(board_rules.legal_move?(piece, [1, 1])).to be false
    end

    it 'returns true if the move is valid' do
      allow(board).to receive(:find_piece).with(piece).and_return([0, 0])
      allow(board_rules).to receive(:path_clear?).with([0, 0], [1, 1]).and_return(true)

      expect(board_rules.legal_move?(piece, [1, 1])).to be true
    end
  end

  describe '#path_clear?' do
    it 'returns false if there is an obstacle in the path' do
      allow(board).to receive(:empty?).with(1, 1).and_return(false)

      expect(board_rules.path_clear?([0, 0], [2, 2])).to be false
    end

    it 'returns true if the path is clear' do
      allow(board).to receive(:empty?).with(1, 1).and_return(true)

      expect(board_rules.path_clear?([0, 0], [2, 2])).to be true
    end
  end

  describe '#filter_moves' do
    it 'filters out invalid moves' do
      moves = [[1, 2], [3, 4], [5, 6]]
      allow(board_rules).to receive(:legal_move?).with(piece, [1, 2]).and_return(true)
      allow(board_rules).to receive(:legal_move?).with(piece, [3, 4]).and_return(false)
      allow(board_rules).to receive(:legal_move?).with(piece, [5, 6]).and_return(true)

      expect(board_rules.filter_moves(piece, moves)).to eq([[1, 2], [5, 6]])
    end
  end
end
