require 'rspec'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/player'

RSpec.describe 'Connect Four' do
  let(:player1) { Player.new('Alice', :red) }
  let(:player2) { Player.new('Bob', :yellow) }
  let(:game) { Game.new(player1, player2) }
  let(:board) { game.board }

  describe Board do
    describe '#place_piece' do
      it 'places a piece in the lowest available row of a column' do
        board.place_piece(0, :red)
        expect(board.grid[0][5]).to eq(:red) # Check the bottom row (index 5)

        board.place_piece(0, :yellow)
        expect(board.grid[0][4]).to eq(:yellow) # Check the second from bottom row
      end

      it 'raises an error when trying to place a piece in a full column' do
        6.times { board.place_piece(0, :red) }
        expect { board.place_piece(0, :yellow) }.to raise_error(StandardError, 'Column is full')
      end
    end

    describe '#winning_move?' do
      it 'detects a horizontal win' do
        4.times { |i| board.place_piece(i, :red) }
        expect(board.winning_move?(3, :red)).to be true
      end

      it 'detects a vertical win' do
        4.times { board.place_piece(0, :yellow) }
        expect(board.winning_move?(0, :yellow)).to be true
      end

      it 'detects a diagonal win (bottom-left to top-right)' do
        3.times { |i| (i + 1).times { board.place_piece(i, :red) } }
        4.times { board.place_piece(3, :red) }
        expect(board.winning_move?(3, :red)).to be true
      end

      it 'detects a diagonal win (top-left to bottom-right)' do
        3.times { |i| (3 - i).times { board.place_piece(i, :yellow) } }
        board.place_piece(3, :yellow)
        expect(board.winning_move?(3, :yellow)).to be true
      end

      it 'returns false when there is no win' do
        3.times { |i| board.place_piece(i, :red) }
        expect(board.winning_move?(2, :red)).to be false
      end

      it 'detects a horizontal win in the middle rows' do
        board = Board.new
        board.instance_variable_set(:@grid, [
                                      [nil, nil, nil, nil, :red, :yellow, nil],
                                      [nil, :yellow, :red, :red, :yellow, :red, nil],
                                      [nil, nil, :red, :yellow, :red, :red, nil],
                                      [nil, nil, :red, :yellow, :yellow, :yellow, nil],
                                      [nil, nil, nil, :yellow, :yellow, :yellow, nil],
                                      [nil, nil, :red, :yellow, :yellow, :yellow, nil],
                                      [nil, nil, nil, nil, :red, :yellow, nil]
                                    ])
        expect(board.winning_move?(4, :yellow)).to be true
      end

      it 'detects a diagonal win (bottom-left to top-right)' do
        board = Board.new
        board.instance_variable_set(:@grid, [
                                      [:red, nil, nil, nil, nil, nil],
                                      [:yellow, :red, nil, nil, nil, nil],
                                      [:red, :yellow, :red, nil, nil, nil],
                                      [:yellow, :yellow, :red, :red, nil, nil],
                                      [:red, :yellow, :red, :yellow, nil, nil],
                                      [:yellow, :red, :yellow, :red, nil, nil],
                                      [nil, nil, nil, nil, nil, nil]
                                    ])
        expect(board.winning_move?(3, :red)).to be true
      end
    end

    describe '#full?' do
      it 'returns true when the board is full' do
        7.times do |col|
          6.times do |row|
            board.place_piece(col, %i[red yellow][(col + row) % 2])
          end
        end
        expect(board.full?).to be true
      end

      it 'returns false when the board is not full' do
        expect(board.full?).to be false
      end
    end
  end

  describe Game do
    describe '#play_turn' do
      it 'returns :won when a player wins' do
        # Set up a winning condition (4 in a row horizontally)
        3.times do |i|
          game.play_turn(i)  # Player 1 plays
          game.play_turn(i)  # Player 2 plays above
        end
        expect(game.play_turn(3)).to eq(:won) # Player 1 wins
      end

      it 'returns :draw when the board is full without a winner' do
        # Fill the board in a way that doesn't result in a win
        [
          %i[red yellow red yellow red yellow],
          %i[yellow red yellow red yellow red],
          %i[yellow red yellow red yellow red],
          %i[red yellow red yellow red yellow],
          %i[red yellow red yellow red yellow],
          %i[yellow red yellow red yellow red],
          %i[red yellow red yellow red]
        ].each_with_index do |column, col_index|
          column.each do |color|
            game.instance_variable_set(:@current_player, color == :yellow ? player1 : player2)
            game.play_turn(col_index)
          end
        end

        # The last move should result in a draw
        game.instance_variable_set(:@current_player, player1)
        expect(game.play_turn(6)).to eq(:draw)

        # Verify that the board is indeed full
        expect(game.board.full?).to be true
      end

      it 'returns :invalid for an invalid move' do
        6.times { game.play_turn(0) } # Fill up column 0
        expect(game.play_turn(0)).to eq(:invalid)
      end

      it 'switches players after a valid move' do
        expect(game.current_player).to eq(player1)
        game.play_turn(0)
        expect(game.current_player).to eq(player2)
      end
    end
  end

  describe Player do
    it 'has a name and a color' do
      expect(player1.name).to eq('Alice')
      expect(player1.color).to eq(:red)
    end
  end
end
