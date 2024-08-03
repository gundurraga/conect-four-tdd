require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

RSpec.describe Game do
  let(:player1) { Player.new('Alice', :red) }
  let(:player2) { Player.new('Bob', :yellow) }
  let(:game) { Game.new(player1, player2) }

  describe '#initialize' do
    it 'creates a game with two players and a board' do
      expect(game.players).to contain_exactly(player1, player2)
      expect(game.board).to be_a(Board)
      expect(game.current_player).to eq(player1)
    end
  end

  describe '#play_turn' do
    context 'when the move is valid' do
      before do
        allow(game.board).to receive(:place_piece).and_return(0)
      end

      it 'allows the current player to make a move and switches players' do
        expect(game.board).to receive(:place_piece).with(3, :red)
        expect(game.board).to receive(:winning_move?).with(3, :red).and_return(false)
        expect(game.board).to receive(:full?).and_return(false)
        expect(game.play_turn(3)).to eq(:continue)
        expect(game.current_player).to eq(player2)
      end

      it 'ends the game when a winning move is made' do
        expect(game.board).to receive(:place_piece).with(3, :red)
        expect(game.board).to receive(:winning_move?).with(3, :red).and_return(true)
        expect(game.play_turn(3)).to eq(:won)
      end

      it 'ends the game when the board becomes full after making a move' do
        expect(game.board).to receive(:place_piece).with(0, :red)
        expect(game.board).to receive(:winning_move?).with(0, :red).and_return(false)
        expect(game.board).to receive(:full?).and_return(true)
        expect(game.play_turn(0)).to eq(:draw)
      end
    end

    context 'when the move is invalid' do
      it 'returns :invalid for an out-of-bounds column' do
        expect(game.play_turn(7)).to eq(:invalid)
        expect(game.play_turn(-1)).to eq(:invalid)
      end

      it 'returns :invalid for a full column' do
        allow(game.board).to receive(:place_piece).and_raise(StandardError.new('Column is full'))
        expect(game.play_turn(0)).to eq(:invalid)
      end
    end
  end

  describe '#full?' do
    it 'returns true when the board is full' do
      allow(game.board).to receive(:full?).and_return(true)
      expect(game).to be_full
    end

    it 'returns false when the board is not full' do
      allow(game.board).to receive(:full?).and_return(false)
      expect(game).not_to be_full
    end
  end
end
