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
