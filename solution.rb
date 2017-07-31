# included in Board to find a solution to a sudoku puzzle represented
# => by a Board object
module Solution
  def solved?
    (@tiles.select { |tile| tile.int.nil? }).empty?
  end

  def solve
    solution_state = nil
    until solved?
      print_board unless @tiles.map(&int) == solution_state
      solution_state = @tiles.map(&int)
      progress = solution_iteration
      raise 'intractable' unless progress
    end
    print_board
    puts 'Solved!'
  end

  def solution_iteration
    iterate_mustcontains || iterate_tiles || nil
  end

  def iterate_mustcontains
    @mustcontains.each do |mc|
      progress = mc.update
      return progress if progress
    end
    nil
  end

  def iterate_tiles
    @tiles.each do |tile|
      if tile.int_possibilities.count == 1
        tile.int = tile.int_possibilities.first
        return :narrow_int_possibilites
      end
    end
    nil
  end
end
