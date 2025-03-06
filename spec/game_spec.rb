require_relative '../lib/game'

RSpec.describe Game do
  let(:game) { Game.new }

  describe '#initialize' do
    it 'creates a new board' do
      expect(game.board).to be_a(Board)
    end

    it 'sets current player to white' do
      expect(game.instance_variable_get(:@current_player)).to eq(:white)
    end
  end

  describe '#switch_player' do
    it 'changes player from white to black' do
      game.instance_variable_set(:@current_player, :white)
      game.switch_player
      expect(game.instance_variable_get(:@current_player)).to eq(:black)
    end

    it 'changes player from black to white' do
      game.instance_variable_set(:@current_player, :black)
      game.switch_player
      expect(game.instance_variable_get(:@current_player)).to eq(:white)
    end
  end

  describe '#other_color' do
    it 'returns black when current player is white' do
      game.instance_variable_set(:@current_player, :white)
      expect(game.other_color).to eq(:black)
    end

    it 'returns white when current player is black' do
      game.instance_variable_set(:@current_player, :black)
      expect(game.other_color).to eq(:white)
    end
  end

  describe '#to_human_position' do
    it 'converts coordinates back to chess notation' do
      expect(game.to_human_position([7, 0])).to eq('a1')
      expect(game.to_human_position([0, 7])).to eq('h8')
      expect(game.to_human_position([4, 4])).to eq('e4')
    end
  end

  describe '#check_for_check' do
    it 'outputs message when player is in check' do
      allow(game.instance_variable_get(:@board_rules)).to receive(:in_check?).and_return(true)
      expect(game).to receive(:puts).with('White is in check!')
      game.check_for_check
    end

    it 'does nothing when player is not in check' do
      allow(game.instance_variable_get(:@board_rules)).to receive(:in_check?).and_return(false)
      expect(game).not_to receive(:puts).with('White is in check!')
      game.check_for_check
    end
  end

  describe '#parse_position' do
    it 'returns nil for invalid inputs' do
      expect(game.send(:parse_position, nil)).to be_nil
      expect(game.send(:parse_position, 'i1')).to be_nil
      expect(game.send(:parse_position, 'a9')).to be_nil
      expect(game.send(:parse_position, 'aa')).to be_nil
    end
  end

  describe '#prompt_for_input' do
    it 'displays correct prompt and returns user input' do
      expect(game).to receive(:puts).with("White's turn. Enter your move (e.g., e2 e4):")
      allow(game).to receive(:gets).and_return("e2 e4\n")
      expect(game.prompt_for_input).to eq('e2 e4')
    end
  end

  describe '#check_for_checkmate' do
    it 'outputs message and exits when checkmate is detected' do
      allow(game.instance_variable_get(:@board_rules)).to receive(:checkmate?).and_return(true)
      allow(game).to receive(:puts)
      allow(game.board).to receive(:display)
      expect(game).to receive(:puts).with('Checkmate!')
      expect(game).to receive(:puts).with('Black wins!')
      expect(game).to receive(:exit)
      game.check_for_checkmate
    end

    it 'does nothing when not in checkmate' do
      allow(game.instance_variable_get(:@board_rules)).to receive(:checkmate?).and_return(false)
      expect(game).not_to receive(:puts).with('Checkmate!')
      expect(game).not_to receive(:exit)
      game.check_for_checkmate
    end
  end
end
