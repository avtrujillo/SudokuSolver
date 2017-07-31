# from http://rubyquiz.com/quiz43.html

require 'byebug'
require 'set'

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

class MustContain
=begin
This is to be used in situations where one of a given set of tiles must be a
particular integer.
=end
  attr_accessor :int, :tiles, :solved, :ninegroup
  def initialize(int, tiles) # tiles should be a set
    @int = int
    @tiles = tiles.to_set
    raise "Has #{@tiles.count} tiles instead of 9" unless @tiles.count == 9
    @candidate_tiles = @tiles.dup
  end
  def ==(other)
    other.int == @int && other.tiles == @tiles
  end
  def eql?(other)
    # not sure if I'll need this, but might as well make it while I'm thinking
    # of it
    other.instance_of?(self.class) && other == self
  end
  def update
    @progress = false
    return @progress if @solved # will return false
    @progress = :removed_nil if @candidate_tiles.select! {|tile| tile.int.nil?}
    if @tiles.find {|tile| tile.int == @int}
      self.solution_found # will set @progress to true
    elsif @candidate_tiles.count == 1
      @candidate_tiles.to_a.first.int = @int
      self.solution_found # will set @progress to true
    elsif @candidate_tiles.select! {|tile| tile.int_possibilities.include?(@int)}
      @progress = :removed_candidates
    end
    @progress
  end
  def solution_found
    @tiles.each do |tile|
      tile.update_int_possibilities([@int]) unless tile.int == @int
    end
    @candidate_tiles = Set.new
    @progress = :solution
    @solved = true
  end
end

class NineGroup
  attr_reader :tiles, :board, :mustcontains
  ONE_THRU_NINE = (1..9).to_set
  def initialize(*args)
    @tiles = self.find_tiles
    raise "Has #{@tiles.count} tiles instead of 9" unless @tiles.count == 9
    @mustcontains = (1..9).map do |int|
      mc = MustContain.new(int, @tiles)
      mc.ninegroup = self
      mc
    end
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
          ints << char.to_i
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

module Solution
  def solved?
    (@tiles.select {|tile| tile.int.nil?}).empty?
  end
  def solve
    solution_state = nil
    until self.solved?
      self.print_board if @tiles.map {|tile| tile.int} != solution_state
      solution_state = @tiles.map {|tile| tile.int}
      progress = self.solution_iteration
      raise "intractable" unless progress
    end
    self.print_board
    puts "Solved!"
  end
  def solution_iteration
    progress = nil
    bar = @mustcontains.find do |mc|
      mc.ninegroup.is_a?(InnerSquare) &&
      mc.int == 9 &&
      mc.ninegroup.x_axis_range == (4..6) &&
      mc.ninegroup.y_axis_range == (4..6)
    end
    @mustcontains.each do |mc|
      progress = mc.update
      return progress if progress
    end
    @tiles.each do |tile|
      if tile.int_possibilities.count == 1
        byebug if tile.int_possibilities.first == 9
        byebug if tile.x_axis == 6 && tile.y_axis == 5
        tile.int = tile.int_possibilities.first
        progress = :narrow_int_possibilites
        return progress
      end
    end
    progress
  end
end

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

new_board = Board.create_board_from_input.solve
