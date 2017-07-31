# a row of tiles on the board
class Row < NineGroup
  attr_reader :y_axis
  def initialize(y_axis, board)
    @board = board
    @y_axis = y_axis
    super
  end

  def find_tiles
    @board.tiles.select { |tile| tile.y_axis == @y_axis }
  end

  def row_display_string
    row_string = (1..9).each_with_object('| ') do |x, rstring|
      tile = @tiles.find { |t| t.x_axis == x }
      rstring << (tile.int ? "#{tile.int} " : '_ ')
      rstring << '| ' if (x % 3).zero?
    end
    row_string
  end
end
