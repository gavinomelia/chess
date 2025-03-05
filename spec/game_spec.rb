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
end
