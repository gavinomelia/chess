require 'spec_helper'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/board'

RSpec.describe Pawn do
  let(:board) { Board.new }
  let(:white_pawn) { Pawn.new(:white, board) }
  let(:black_pawn) { Pawn.new(:black, board) }

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
        expect(white_pawn.find_moves([1, 0])).to contain_exactly([2, 0], [3, 0])
      end

      it 'returns possible moves for a black pawn' do
        expect(black_pawn.find_moves([6, 0])).to contain_exactly([5, 0], [4, 0])
      end

      it 'returns moves within the board for a white pawn' do
        expect(white_pawn.find_moves([1, 0])).to contain_exactly([2, 0], [3, 0])
      end

      it 'returns moves within the board for a black pawn' do
        expect(black_pawn.find_moves([6, 0])).to contain_exactly([5, 0], [4, 0])
      end

      it 'does not return moves outside the board' do
        expect(white_pawn.find_moves([8, 0])).to be_empty
      end

      context 'when on starting row' do
        it 'returns two moves for a white pawn' do
          expect(white_pawn.on_starting_row?([1, 0])).to be true
          expect(white_pawn.find_moves([1, 0])).to contain_exactly([2, 0], [3, 0])
        end

        it 'returns two moves for a black pawn' do
          expect(black_pawn.on_starting_row?([6, 0])).to be true
          expect(black_pawn.find_moves([6, 0])).to contain_exactly([5, 0], [4, 0])
        end
      end
    end

    context 'when pawns are not on their starting positions' do
      before do
        board.place_piece(white_pawn, [2, 0])
        board.place_piece(black_pawn, [5, 0])
      end

      it 'returns one move for a white pawn' do
        expect(white_pawn.on_starting_row?([2, 0])).to be false
        expect(white_pawn.find_moves([2, 0])).to contain_exactly([3, 0])
      end

      it 'returns one move for a black pawn' do
        expect(black_pawn.on_starting_row?([5, 0])).to be false
        expect(black_pawn.find_moves([5, 0])).to contain_exactly([4, 0])
      end
    end

    context 'when captures are available' do
      before do
        board.place_piece(white_pawn, [1, 0])
        board.place_piece(black_pawn, [6, 0])
        board.place_piece(Pawn.new(:black, board), [2, 1])
        board.place_piece(Pawn.new(:white, board), [5, 1])
      end

      it 'returns capture moves for a white pawn' do
        expect(white_pawn.find_moves([1, 0])).to contain_exactly([2, 0], [3, 0], [2, 1])
      end

      it 'returns capture moves for a black pawn' do
        expect(black_pawn.find_moves([6, 0])).to contain_exactly([5, 0], [4, 0], [5, 1])
      end
    end
  end
end
