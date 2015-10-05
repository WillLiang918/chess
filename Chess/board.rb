require_relative 'piece'

PIECE_TYPE = {

}

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
    self.in_bounds?(end_pos)
  end

  def in_bounds?(pos)
    pos.all? do |coordinate|
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
    create_pawn_rows
    create_back_rows
  end

  def create_pawn_rows
    @grid[1].each_index do |i|
      self[[1, i]] = create_new_piece([1, i], :p)
    end
    @grid[6].each_index do |i|
      self[[6, i]] = create_new_piece([6, i], :p)
    end
  end

  def create_back_rows
    [:r, :h, :b, :q, :k, :b, :h, :r].each_with_index do |piece, i|
      self[[0, i]] = create_new_piece([0, i], piece)
      self[[7, i]] = create_new_piece([7, i], piece)
    end
  end

  def create_new_piece(pos, symbol)
    case symbol
    when :r, :b, :q
      SlidingPiece.new(pos, self, symbol)
    when :h
    when :k
    when :p
      Pawn.new(pos, self, symbol)
    end

  end

end

b = Board.new
pos = [4,4]
sp = SlidingPiece.new(pos, b)
p sp.hor_and_ver_moves
p sp.hor_and_ver_moves.length
