#This is to be used in situations where one of a given set of tiles must be a
# => particular integer.
class MustContain
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
    # => of it
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
