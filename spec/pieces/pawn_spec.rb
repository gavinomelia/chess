require 'rspec'
require_relative '../../lib/pieces/pawn'

RSpec.describe Pawn do
  let(:white_pawn) { Pawn.new(:white, [1, 0]) }
  let(:black_pawn) { Pawn.new(:black, [6, 0]) }

  describe '#initialize' do
    it 'creates a white pawn' do
      expect(white_pawn.color).to eq(:white)
      expect(white_pawn.position).to eq([1, 0])
    end

    it 'creates a black pawn' do
      expect(black_pawn.color).to eq(:black)
      expect(black_pawn.position).to eq([6, 0])
    end
  end

  describe '#find_moves' do
    it 'returns possible moves for a white pawn' do
      expect(white_pawn.find_moves([1, 0])).to contain_exactly([2, 0], [3, 0])
    end

    it 'returns possible moves for a black pawn' do
      expect(black_pawn.find_moves([6, 0])).to contain_exactly([7, 0], [8, 0])
    end
  end

  describe '#possible_moves' do
    it 'returns moves within the board for a white pawn' do
      expect(white_pawn.possible_moves([1, 0])).to contain_exactly([2, 0], [3, 0])
    end

    it 'returns moves within the board for a black pawn' do
      expect(black_pawn.possible_moves([6, 0])).to contain_exactly([7, 0], [8, 0])
    end

    it 'does not return moves outside the board' do
      expect(white_pawn.possible_moves([8, 0])).to be_empty
    end

    context 'when on starting row' do
      let(:white_pawn) { Pawn.new(:white, [1, 0]) }
      let(:black_pawn) { Pawn.new(:black, [6, 0]) }
      it 'returns two moves for a white' do
        expect(white_pawn.on_starting_row?).to be true
        expect(white_pawn.pawn_moves).to eq([[1, 0], [2, 0]])
      end

      it 'returns two moves for a black' do
        expect(black_pawn.on_starting_row?).to be true
        expect(black_pawn.pawn_moves).to eq([[1, 0], [2, 0]])
      end
    end

    context 'when not on starting row' do
      let(:white_pawn) { Pawn.new(:white, [2, 0]) }
      let(:black_pawn) { Pawn.new(:black, [5, 0]) }
      it 'returns one move for a white' do
        expect(white_pawn.on_starting_row?).to be false
        expect(white_pawn.pawn_moves).to eq([[1, 0]])
      end

      it 'returns one move for a black' do
        expect(black_pawn.on_starting_row?).to be false
        expect(black_pawn.pawn_moves).to eq([[1, 0]])
      end
    end
  end
end