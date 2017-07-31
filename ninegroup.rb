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
