class Row < NineGroup
  attr_reader :y_axis
  def initialize(y_axis, board)
    @board = board
    @y_axis = y_axis
    super
  end
  def find_tiles
    @board.tiles.select {|tile| tile.y_axis == self.y_axis}
  end
  def row_display_string
    row_string = "| "
    for x in (1..9)
      tile = @tiles.find {|tile| tile.x_axis == x}
      if tile.int
        row_string += "#{tile.int} "
      else
        row_string += "_ "
      end
      row_string += "| " if x % 3 == 0
    end
    row_string
  end
end
