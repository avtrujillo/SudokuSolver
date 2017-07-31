# a column of tiles on the board
class Column < NineGroup
  attr_reader :x_axis
  def initialize(x_axis, board)
    @board = board
    @x_axis = x_axis
    super
  end

  def find_tiles
    @board.tiles.select { |tile| tile.x_axis == @x_axis }
  end
end
