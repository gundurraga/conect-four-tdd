class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(7) { Array.new(6) }
  end

  def place_piece(column, piece)
    row = @grid[column].rindex(nil)
    raise StandardError, 'Column is full' if row.nil?

    @grid[column][row] = piece
    row
  end

  def winning_move?(column, piece)
    row = @grid[column].rindex(piece)
    return false unless row

    check_horizontal(row, piece) ||
      check_vertical(column, piece) ||
      check_diagonal(row, column, piece)
  end

  def full?
    @grid.all? { |column| column.all? { |cell| !cell.nil? } }
  end

  private

  def check_horizontal(row, piece)
    count = 0
    @grid.each do |column|
      if column[row] == piece
        count += 1
        return true if count >= 4
      else
        count = 0
      end
    end
    false
  end

  def check_vertical(column, piece)
    @grid[column].count(piece) >= 4
  end

  def check_diagonal(row, column, piece)
    directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

    directions.any? do |row_dir, col_dir|
      count = 1 # Start at 1 to include the piece just placed
      1.upto(3) do |i|
        r = row + i * row_dir
        c = column + i * col_dir
        break if !valid_position?(r, c) || @grid[c][r] != piece

        count += 1
      end
      -1.downto(-3) do |i|
        r = row + i * row_dir
        c = column + i * col_dir
        break if !valid_position?(r, c) || @grid[c][r] != piece

        count += 1
      end
      count >= 4
    end
  end

  def valid_position?(row, col)
    row.between?(0, 5) && col.between?(0, 6)
  end
end
