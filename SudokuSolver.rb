# from http://rubyquiz.com/quiz43.html

require 'byebug'

class Tile
  ONE_THRU_NINE = (1..9).to_a
  attr_reader :x_axis, :y_axis, :int_possibilities
  attr_accessor :int, :board
  def initialize(x_axis, y_axis, int, board)
    @int = int
    @x_axis = x_axis
    @y_axis = y_axis
    @board = board
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
  def ninegroups
    [self.row, self.column, self.inner_square]
  end
  def ninegroups_used_ints
    ng_used_ints = self.ninegroups.map {|ng| ng.used_ints}
    ng_used_ints.uniq!
    ng_used_ints
  end
  def find_int_possibilities
    ONE_THRU_NINE - self.ninegroups_used_ints
  end
  def int_update
    @int_possibilities = self.find_int_possibilities
    @int = @int_possibilities.first if @int_possibilities.count == 1
  end
end

class MustContain
=begin
This is to be used in situations where one of a given set of tiles must be a
particular integer.
=end
  attr_accessor :int, :tiles
  def initialize(int, tiles)
    @int = int
    @tiles = tiles
  end
  def ==(other)
    other.int == @int && other.tiles == @tiles
  end
end

class NineGroup
  attr_reader :tiles, :board
  ONE_THRU_NINE = (1..9).to_a
  def initialize(*args)
    @tiles = self.find_tiles
  end
  def unsolved_tiles
    @tiles.select {|tile| tile.int.nil?}
  end
  def solved?
    self.unsolved_tiles.empty?
  end
  def used_ints
    (@tiles.map {|tile| tile.int}).compact
  end
  def unused_ints
    ONE_THRU_NINE - self.unused_ints
  end
end

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

class Column < NineGroup
  attr_reader :x_axis
  def initialize(x_axis, board)
    @board = board
    @x_axis = x_axis
    super
  end
  def find_tiles
    @board.tiles.select {|tile| tile.x_axis == self.x_axis}
  end
end

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

module ImportBoard
  def get_board_lines
    Dir.chdir(__dir__)
    raise unless File.exist?("input.txt")
    board_lines = IO.readlines("input.txt")
  end
  def remove_horizontal_bars(board_lines)
    board_lines.select {|line| line[0] != "+"}
  end
  def int_rows_from_lines(board_lines)
    board_lines.map do |line|
      line.chars.inject(Array.new) do |ints, char|
        if (1..9).include?(char.to_i)
          ints << char
        elsif char == "_"
          ints << nil
        end
        ints
      end
    end
  end
  def create_tiles_from_input(int_rows)
    tiles = Array.new
    int_rows.each_with_index do |row, y|
      row.each_with_index do |int, x|
        tiles << Tile.new((x + 1), (y + 1), int, nil)
      end
    end
    tiles.flatten
  end
  def create_board_from_input
    board_lines = self.get_board_lines
    board_rows = self.remove_horizontal_bars(board_lines)
    int_rows = self.int_rows_from_lines(board_rows)
    tiles = self.create_tiles_from_input(int_rows)
    board_from_input = Board.new(tiles)
    board_from_input.tiles.each {|tile| tile.board = board_from_input}
    board_from_input
  end
end

class Board
  extend ImportBoard
  attr_reader :tiles, :columns, :rows, :inner_squares
  def initialize(tiles)
    @tiles = tiles
    self.create_columns
    self.create_rows
    self.create_inner_squares
  end
  def create_rows
    @rows = Array.new
    for y in (1..9)
      @rows << Row.new(y, self)
    end
  end
  def create_columns
    @columns = Array.new
    for x in (1..9)
      @columns << Column.new(x, self)
    end
  end
  def create_inner_squares
    @inner_squares = Array.new
    ranges = [(1..3), (4..6), (7..9)]
    range_pairs = ranges.repeated_permutation(2)
    range_pairs.each do |rp|
      @inner_squares << InnerSquare.new(rp[0], rp[1], self)
    end
  end
  HORIZONTAL_BAR = "+-------+-------+-------+"
  def print_board
    puts HORIZONTAL_BAR
    @rows.each_with_index do |row, y|
      puts row.row_display_string
      puts HORIZONTAL_BAR if (y + 1) % 3 == 0
    end
  end
  def solved?
    (@tiles.select {|tile| tile.int.nil?}).empty?
  end
  def solve #unfinished
    self.print_board
    foo = @tiles.map {|tile| tile.int}
    until self.solved?
      self.print_board unless foo == @tiles.map {|tile| tile.int}
      foo = @tiles.map {|tile| tile.int}
      @tiles.each {|tile| tile.int_update}
    end
  end
end

new_board = Board.create_board_from_input.solve
