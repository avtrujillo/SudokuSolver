# A group of nine tiles that must contain each integer in (1..9) exactly once.
# => Row, Column, and InnerSquare all inherit from it
class NineGroup
  attr_reader :tiles, :board, :mustcontains
  def initialize(board)
    @board = board
    @tiles = find_tiles
    raise "Has #{@tiles.count} tiles instead of 9" unless @tiles.count == 9
    @mustcontains = (1..9).map do |int|
      mc = MustContain.new(int, @tiles)
      mc.ninegroup = self
      mc
    end
  end
end
