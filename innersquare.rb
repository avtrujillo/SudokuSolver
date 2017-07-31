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
      @x_axis_range === tile.x_axis && @y_axis_range === tile.y_axis
    end
  end
end
