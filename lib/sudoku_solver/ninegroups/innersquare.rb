# This is a group of nine tiles arranged in a square in the sudoku puzzle,
#  of which there are nine in the entire puzzle. As an example:
#  123
#  456
#  789
#  would be a an inner square. Since this is a ninegroup, it can only contain
#  one of each integer (1..9).
class InnerSquare < NineGroup
  attr_reader :x_axis_range, :y_axis_range
  def initialize(x_axis_range, y_axis_range, board)
    @board = board
    @x_axis_range = x_axis_range
    @y_axis_range = y_axis_range
    super
  end

  def find_tiles
    @board.tiles.select do |tile|
      @x_axis_range.cover?(tile.x_axis) && @y_axis_range.cover?(tile.y_axis)
    end
  end
end
