require_relative '../lib/game'

RSpec.describe Game do
  let(:game) { Game.new }

  describe '#parse_position' do
    it 'converts chess notation to array indexes' do
      # Since parse_position is private, we need to use send
      expect(game.send(:parse_position, 'a1')).to eq([7, 0])
      expect(game.send(:parse_position, 'h8')).to eq([0, 7])
      expect(game.send(:parse_position, 'e4')).to eq([4, 4])
      expect(game.send(:parse_position, 'c6')).to eq([2, 2])
    end
  end

  describe '#parse_input' do
    it 'converts user input to coordinate pairs' do
      expect(game.send(:parse_input, 'e2 e4')).to eq([[6, 4], [4, 4]])
      expect(game.send(:parse_input, 'a1 h8')).to eq([[7, 0], [0, 7]])
    end
  end

  describe '#check_for_checkmate' do
    it 'exits the program when checkmate is detected' do
      allow(game.instance_variable_get(:@board_rules)).to receive(:checkmate?).and_return(true)
      allow(game.instance_variable_get(:@board)).to receive(:print_board)
      expect(game).to receive(:puts).with('Checkmate!')
      expect(game).to receive(:puts).with('Black wins!')
      expect(game).to receive(:exit)
      game.check_for_checkmate(color: :white)
    end

    it 'does nothing when there is no checkmate' do
      allow(game.instance_variable_get(:@board_rules)).to receive(:checkmate?).and_return(false)
      expect(game).not_to receive(:puts).with('Checkmate!')
      expect(game).not_to receive(:exit)
      expect { game.check_for_checkmate }.not_to raise_error
    end
  end
end
