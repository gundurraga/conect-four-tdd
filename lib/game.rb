class Game
  attr_reader :players, :board, :current_player

  def initialize(player1, player2)
    @players = [player1, player2]
    @board = Board.new
    @current_player = player1
  end

  def play_turn(column)
    return :invalid unless valid_move?(column)

    begin
      row = @board.place_piece(column, @current_player.color)
    rescue StandardError => e
      return :invalid if e.message == 'Column is full'

      raise e # Re-raise any unexpected errors
    end

    if @board.winning_move?(column, @current_player.color)
      return :won
    elsif @board.full?
      return :draw
    end

    switch_players
    :continue
  end

  def full?
    @board.full?
  end

  private

  def valid_move?(column)
    column.between?(0, 6)
  end

  def switch_players
    @current_player = (@current_player == @players[0] ? @players[1] : @players[0])
  end
end
