class Tile
  ONE_THRU_NINE = (1..9).to_set
  attr_reader :x_axis, :y_axis, :int_possibilities
  attr_accessor :board, :int
  def initialize(x_axis, y_axis, int, board)
    @int = int
    @x_axis = x_axis
    @y_axis = y_axis
    @board = board
    if @int
      @int_possibilities = Set.new
    else
      @int_possibilities = (1..9).to_set
    end
  end
  def row
    @board.rows.find {|row| row.y_axis == self.y_axis}
  end
  def column
    @board.columns.find {|column| column.x_axis == self.x_axis}
  end
  def inner_square
    @board.inner_squares.find do |square|
      raise "InnerSquare doesn't have nine tiles" unless square.tiles.count == 9
      square.tiles.include?(self)
    end
  end
  def update_int_possibilities(array_or_set_of_ints_to_be_removed)
    byebug if @x_axis == 6 && @y_axis == 5 && array_or_set_of_ints_to_be_removed.include?(2)
    @int_possibilities -= array_or_set_of_ints_to_be_removed
    if @int_possibilities.count == 1
      @int = @int_possibilities.first
      @int_possibilities = Set.new
    elsif
      @int_possibilities.count == 0 && !@int
      raise "zero possible integers for tile"
    end
  end
end
