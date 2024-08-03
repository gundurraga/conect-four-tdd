require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/board'
require 'colorize'

class ConnectFour
  EMPTY_CELL = '⚪'
  RED_CHIP = '🔴'
  YELLOW_CHIP = '🟡'

  def initialize
    @game = nil
  end

  def start
    puts 'Welcome to Connect Four!'.colorize(:light_blue)
    setup_players
    play_game
    end_game
  end

  private

  def setup_players
    puts "Enter name for Player 1 (#{RED_CHIP}):"
    player1 = Player.new(gets.chomp, :red)
    puts "Enter name for Player 2 (#{YELLOW_CHIP}):"
    player2 = Player.new(gets.chomp, :yellow)
    @game = Game.new(player1, player2)
  end

  def play_game
    loop do
      display_board
      puts "#{@game.current_player.name}'s turn (#{chip_for(@game.current_player.color)})."
      column = get_player_move
      result = @game.play_turn(column)
      case result
      when :won
        display_board
        puts "#{@game.current_player.name} wins!".colorize(:green)
        break
      when :draw
        display_board
        puts "It's a draw!".colorize(:yellow)
        break
      when :invalid
        puts 'Invalid move. Try again.'.colorize(:red)
      end
    end
  end

  def get_player_move
    loop do
      print 'Enter column number (0-6): '
      input = gets.chomp
      return input.to_i if input =~ /^[0-6]$/

      puts 'Invalid input. Please enter a number between 0 and 6.'.colorize(:red)
    end
  end

  def display_board
    puts "\n" + '0  1  2  3  4  5  6'.colorize(:light_blue)
    6.times do |row|
      line = 7.times.map do |col|
        case @game.board.grid[col][row]
        when :red then RED_CHIP
        when :yellow then YELLOW_CHIP
        else EMPTY_CELL
        end
      end.join(' ')
      puts line
    end
    puts "\n"
  end

  def chip_for(color)
    color == :red ? RED_CHIP : YELLOW_CHIP
  end

  def end_game
    puts 'Thanks for playing Connect Four!'.colorize(:light_blue)
  end
end

# Start the game
ConnectFour.new.start
