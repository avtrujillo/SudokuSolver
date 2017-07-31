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
