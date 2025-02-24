require_relative '../lib/piece'

RSpec.describe Piece do
  let(:piece) { Piece.new(:knight, :white, [0, 1]) }

  describe '#initialize' do
    context 'when it creates a piece' do
      it 'creates a piece with a color' do
        expect(piece.color).to eq(:white)
      end
      it 'creates a piece with a type' do
        expect(piece.type).to eq(:knight)
      end
      it 'creates a piece with a position' do
        expect(piece.position).to eq([0, 1])
      end
    end
  end
end