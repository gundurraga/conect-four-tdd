require 'spec_helper'
require_relative '../lib/player'
require_relative '../lib/board'

RSpec.describe Player do
  describe '#initialize' do
    it 'creates a player with a name and a valid color' do
      player = Player.new('Alice', :red)
      expect(player.name).to eq('Alice')
      expect(player.color).to eq(:red)
    end

    it 'raises an error if an invalid color is provided' do
      expect { Player.new('Bob', :blue) }.to raise_error(ArgumentError, 'Invalid color')
    end
  end

  describe '#make_move' do
    let(:board) { instance_double('Board') }
    let(:player) { Player.new('Bob', :yellow) }

    it 'places a piece on the board' do
      expect(board).to receive(:place_piece).with(3, :yellow)
      player.make_move(board, 3)
    end

    it 'returns the result of place_piece' do
      allow(board).to receive(:place_piece).with(3, :yellow).and_return(2)
      expect(player.make_move(board, 3)).to eq(2)
    end
  end
end
