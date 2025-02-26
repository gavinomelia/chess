require_relative '../lib/board'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'creates a 8x8 board' do
      expect(board.board.count).to eq(8)
    end
    it 'creates a 8x8 board with all elements initialized to 0' do
      expect(board.board.flatten.all? { |cell| cell == 0 }).to be true
    end
  end
end