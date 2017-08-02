# a tile on a board in a sudoku game
class Tile
  ONE_THRU_NINE = (1..9).to_set
  attr_reader :x_axis, :y_axis, :int_possibilities
  attr_accessor :board, :int
  def initialize(x_axis, y_axis, int, board)
    @int = int
    @x_axis = x_axis
    @y_axis = y_axis
    @board = board
    @int_possibilities = (@int ? Set.new : (1..9).to_set)
  end

  def row
    @board.rows.find { |row| row.y_axis == @y_axis }
  end

  def column
    @board.columns.find { |column| column.x_axis == @x_axis }
  end

  def inner_square
    @board.inner_squares.find do |square|
      raise "InnerSquare doesn't have nine tiles" unless square.tiles.count == 9
      square.tiles.include?(self)
    end
  end

  # int_enum is an array or set of ints to be removed
  def update_int_possibilities(int_enum)
    @int_possibilities -= int_enum
    if @int_possibilities.count == 1
      @int = @int_possibilities.first
      @int_possibilities = Set.new
    elsif @int_possibilities.count.zero? && !@int
      raise 'zero possible integers for tile'
    end
  end
end
