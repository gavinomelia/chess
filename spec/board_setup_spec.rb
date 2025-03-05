require_relative '../lib/board_setup'
require_relative '../lib/board'

RSpec.describe BoardSetup do
  describe '#initial_piece_placement' do
    let(:board) { Board.new }
    before do
      BoardSetup.new(board).initial_piece_placement
    end

    it 'places all pieces in their initial positions' do
      expect(board.grid[0][0]).to be_a(Piece)
      expect(board.grid[7][7]).to be_a(Piece)
    end

    it 'places pawns in the correct rows' do
      expect(board.grid[1].all? { |piece| piece.is_a?(Piece) && piece.type == :pawn }).to be true
      expect(board.grid[6].all? { |piece| piece.is_a?(Piece) && piece.type == :pawn }).to be true
    end

    it 'places rooks in the correct positions' do
      expect(board.grid[0][0].type).to eq(:rook)
      expect(board.grid[0][7].type).to eq(:rook)
      expect(board.grid[7][0].type).to eq(:rook)
      expect(board.grid[7][7].type).to eq(:rook)
    end

    it 'places knights in the correct positions' do
      expect(board.grid[0][1].type).to eq(:knight)
      expect(board.grid[0][6].type).to eq(:knight)
      expect(board.grid[7][1].type).to eq(:knight)
      expect(board.grid[7][6].type).to eq(:knight)
    end

    it 'places bishops in the correct positions' do
      expect(board.grid[0][2].type).to eq(:bishop)
      expect(board.grid[0][5].type).to eq(:bishop)
      expect(board.grid[7][2].type).to eq(:bishop)
      expect(board.grid[7][5].type).to eq(:bishop)
    end

    it 'places queens in the correct positions' do
      expect(board.grid[0][3].type).to eq(:queen)
      expect(board.grid[7][3].type).to eq(:queen)
    end

    it 'places kings in the correct positions' do
      expect(board.grid[0][4].type).to eq(:king)
      expect(board.grid[7][4].type).to eq(:king)
    end
  end
end
