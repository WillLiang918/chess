class Piece

  HOR_MOVES = {
    left: [0, -1],
    right: [0, 1]
  }

  VER_MOVES = {
    up: [-1, 0],
    down: [1, 0]
  }

  DIAG_MOVES = {
    se: [1, 1],
    sw: [1, -1],
    nw: [-1, -1],
    ne: [-1, 1]
  }

  def initialize(pos, board)
    @pos = pos
    @board = board
  end

  def moves(start_pos, end_pos)
    # self.board.move(start_pos, end_pos)
  end

end


class SlidingPiece < Piece

  def initialize(pos, board, type)
    super(pos, board)
    @type = type
  end

end

class DiagonalPiece < SlidingPiece

  def initialize

  end

end


class StraightPiece < SlidingPiece

  def initialize

  end

end
