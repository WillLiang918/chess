require_relative "board"

class Piece

  HOR_AND_VER_MOVES = {
    left: [0, -1],
    right: [0, 1],
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

  def moves
    # self.board.move(start_pos, end_pos)
  end

end


class SlidingPiece < Piece

  def initialize(pos, board, type)
    super(pos, board)
    @type = type
  end

  def moves
    possible_moves = []
    linear_moves = hor_and_ver_moves
    diagonal_moves = diag_moves


    possible_moves
  end

  def hor_and_ver_moves
    possible_moves = []
    HOR_AND_VER_MOVES.each do |direction, diff|
      i = 0
      new_pos = [self.pos[0] + diff[0], self.pos[1] + diff[1]]

      while self.board.in_bounds?(new_pos)
        possible_moves << new_pos
        i += 1
        case direction
        when :left
          new_pos = [self.pos[0] + diff[0], self.pos[1] + diff[1] - i]
        when :right
          new_pos = [self.pos[0] + diff[0], self.pos[1] + diff[1] + i]
        when :up
          new_pos = [self.pos[0] + diff[0] - i, self.pos[1] + diff[1]]
        when :down
          new_pos = [self.pos[0] + diff[0] + i, self.pos[1] + diff[1]]
        end
      end

      possible_moves
    end
  end

  def diag_moves
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

b = Board.new

sp = SlidingPiece.new([0,0], b)

p sp.hor_and_ver_moves
