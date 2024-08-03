class Player
  VALID_COLORS = %i[red yellow]

  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    raise ArgumentError, 'Invalid color' unless VALID_COLORS.include?(color)

    @color = color
  end

  def make_move(board, column)
    board.place_piece(column, @color)
  end
end
