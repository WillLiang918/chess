require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
  end

  def move(start, end_pos)
    raise ArgumentError.new("No piece was selected") if self[start].nil?
    raise ArgumentError.new("This is not a valid move") unless valid_move?(start, end_pos)

    # Only swapping pieces not taking
    self[start], self[end_pos] = self[end_pos], self[start]

    true
  end

  def valid_move?(start, end_pos)
    end_pos.all? do |coordinate|
      coordinate >= 0 && coordinate < self.grid.length
    end
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def populate_board
    @grid[0].each_with_index { |tile, i| self[[0, i]] = Piece.new }
  end

end


a = Board.new
# pa.grid
p a.move([0,0], [2,0])
p a[[0,0]]
p a[[2,0]]
