require 'spec_helper'
require_relative '../lib/piece'
require_relative '../lib/board'

RSpec.describe Piece do
  let(:board) { Board.new }
  let(:piece) { Piece.new(:knight, :white, board) }

  before do
    board.place_piece(piece, [0, 1])
  end

  describe '#initialize' do
    context 'when it creates a piece' do
      it 'creates a piece with a color' do
        expect(piece.color).to eq(:white)
      end

      it 'creates a piece with a type' do
        expect(piece.type).to eq(:knight)
      end
    end
  end
end