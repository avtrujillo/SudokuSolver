# This is to be used in situations where one of a given set of tiles must be a
# => particular integer.
class MustContain
  attr_accessor :int, :tiles, :solved, :ninegroup, :progress, :candidate_tiles
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
    # => of it
    other.instance_of?(self.class) && other == self
  end

  Remove_nil_tiles = proc do |mc|
    if mc.candidate_tiles.select! { |tile| tile.int.nil? }
      mc.progress = :removed_nil
    end
  end

  Int_already_assigned_to_tile = proc do |mc|
    mc.solution_found if mc.tiles.find { |tile| tile.int == mc.int }
    # solution_found will set @progress to :solution
  end

  One_candidate_left = proc do |mc|
    if mc.candidate_tiles.count == 1
      mc.candidate_tiles.to_a.first.int = mc.int
      mc.solution_found # solution_found will set @progress to :solution
    end
  end

  Remove_tiles_without_int_as_a_possibility = proc do |mc|
    select_proc = proc do |tile, int|
      tile.int_possibilities.include?(int)
    end
    if mc.candidate_tiles.select! { |tile| select_proc.call(tile, mc.int) }
      @progress = :removed_candidates
    end
  end

  Update_procs = [
    Remove_nil_tiles,
    Int_already_assigned_to_tile,
    One_candidate_left,
    Remove_tiles_without_int_as_a_possibility
  ].freeze

  def update
    @progress = nil
    return progress if @solved
    Update_procs.each do |p|
      p.call(self)
      return progress if progress
    end
    nil
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
