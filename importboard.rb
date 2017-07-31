# used to generate a Board object from input.txt
module ImportBoard
  def board_lines_from_file
    Dir.chdir(__dir__)
    raise unless File.exist?('input.txt')
    IO.readlines('input.txt')
  end

  def remove_horizontal_bars(board_lines)
    board_lines.reject { |line| line[0] == '+' }
  end

  def int_rows_from_lines(board_lines)
    board_lines.map do |line|
      line.chars.each_with_object([]) do |char, ints|
        if (1..9).cover?(char.to_i)
          ints << char.to_i
        elsif char == '_'
          ints << nil
        end
        ints
      end
    end
  end

  def create_tiles_from_input(int_rows)
    tiles = []
    int_rows.each_with_index do |row, y|
      row.each_with_index do |int, x|
        tiles << Tile.new((x + 1), (y + 1), int, nil)
      end
    end
    tiles.flatten
  end

  def create_board_from_input
    board_lines = board_lines_from_file
    board_rows = remove_horizontal_bars(board_lines)
    int_rows = int_rows_from_lines(board_rows)
    tiles = create_tiles_from_input(int_rows)
    board_from_input = Board.new(tiles)
    board_from_input.tiles.each { |tile| tile.board = board_from_input }
    board_from_input
  end
end
