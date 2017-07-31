class Board
  extend ImportBoard
  include Solution
  attr_reader :tiles, :columns, :rows, :inner_squares, :mustcontains
  def initialize(tiles)
    @tiles = tiles
    @mustcontains = Set.new
    self.create_columns
    self.create_rows
    self.create_inner_squares
  end
  def create_rows
    @rows = Array.new
    for y in (1..9)
      row = Row.new(y, self)
      @rows << row
      @mustcontains += row.mustcontains
    end
  end
  def create_columns
    @columns = Array.new
    for x in (1..9)
      column = Column.new(x, self)
      @columns << column
      @mustcontains += column.mustcontains
    end
  end
  def create_inner_squares
    @inner_squares = Array.new
    ranges = [(1..3), (4..6), (7..9)]
    range_pairs = ranges.repeated_permutation(2)
    range_pairs.each do |rp|
      inner_square = InnerSquare.new(rp[0], rp[1], self)
      @inner_squares << inner_square
      @mustcontains += inner_square.mustcontains
    end
  end
  HORIZONTAL_BAR = "+-------+-------+-------+"
  def print_board
    puts HORIZONTAL_BAR
    @rows.each_with_index do |row, y|
      puts row.row_display_string
      puts HORIZONTAL_BAR if (y + 1) % 3 == 0
    end
    nil
  end
end
