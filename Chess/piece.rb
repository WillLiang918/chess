class Piece

  attr_accessor :pos, :board, :type, :color

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



  def initialize(pos, board, type = nil, color = :white)
    @pos = pos
    @board = board
    @type = type
    @color = color
  end

  def moves
    # self.board.move(start_pos, end_pos)
  end
end

class SlidingPiece < Piece

  # def initialize(pos, board, type = nil)
  #   super(pos, board, type)
  # end

  def moves
  end

  def hor_and_ver_moves
    possible_moves = []
    HOR_AND_VER_MOVES.each do |direction, diff|
      i = 0
      new_pos = [self.pos[0] + diff[0], self.pos[1] + diff[1]]
      new_tile = self.board[new_pos]

      while self.board.in_bounds?(new_pos) && (new_tile.nil? || new_tile.color != self.color)
        possible_moves << new_pos
        break unless new_tile.nil?

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

        new_tile = self.board[new_pos]
      end
    end
    possible_moves
  end

  def diag_moves
    possible_moves = []
    DIAG_MOVES.each do |direction, diff|
      i = 0
      new_pos = [self.pos[0] + diff[0], self.pos[1] + diff[1]]
      new_tile = self.board[new_pos]

      while self.board.in_bounds?(new_pos) && (new_tile.nil? || new_tile.color != self.color)
        possible_moves << new_pos
        break unless new_tile.nil?

        i += 1
        case direction
        when :ne
          new_pos = [self.pos[0] + diff[0] - i, self.pos[1] + diff[1] + i]
        when :nw
          new_pos = [self.pos[0] + diff[0] - i, self.pos[1] + diff[1] - i]
        when :sw
          new_pos = [self.pos[0] + diff[0] + i, self.pos[1] + diff[1] - i]
        when :se
          new_pos = [self.pos[0] + diff[0] + i, self.pos[1] + diff[1] + i]
        end
        new_tile = self.board[new_pos]
      end

    end
    possible_moves
  end

end

class King < Piece

  def moves
    possible_moves = []
    all_directions = HOR_AND_VER_MOVES.merge(DIAG_MOVES)
    all_directions.each do |direction, diff|
      new_pos = [self.pos[0] + diff[0], self.pos[1] + diff[1]]
      new_tile = self.board[new_pos]

      if self.board.in_bounds?(new_pos) && (new_tile.nil? || new_tile.color != self.color)
        possible_moves << new_pos
      end

    end
    possible_moves
  end
end

class Knight < Piece

  KNIGHT_MOVES = [
    [-2, 1],
    [-1, 2],
    [1, 2],
    [2, 1],
    [2, -1],
    [1, -2],
    [-1, -2],
    [-2, -1]
  ]

  def moves
    possible_moves = []

    KNIGHT_MOVES.each do |diff|
      new_pos = [self.pos[0] + diff[0], self.pos[1] + diff[1]]
      new_tile = self.board[new_pos]

      if self.board.in_bounds?(new_pos) && (new_tile.nil? || new_tile.color != self.color)
        possible_moves << new_pos
      end
    end

    possible_moves
  end
end

class Queen < SlidingPiece

  def moves
    possible_moves = []
    possible_moves += hor_and_ver_moves
    possible_moves += diag_moves
    possible_moves
  end
end

class Rook < SlidingPiece

  def moves
    possible_moves = []
    possible_moves += hor_and_ver_moves
    possible_moves
  end
end

class Bishop < SlidingPiece

  def moves
    possible_moves = []
    possible_moves += diag_moves
    possible_moves
  end
end


class Pawn < Piece

  def moves
    possible_moves = []

    if self.color == :black
      forward_move = HOR_AND_VER_MOVES[:up]
    else
      forward_move = HOR_AND_VER_MOVES[:down]
    end

    new_pos = [self.pos[0] + forward_move[0], self.pos[1] + forward_move[1]]
    new_tile = self.board[new_pos]

    if self.board.in_bounds?(new_pos) && new_tile.nil?
      possible_moves << new_pos
    end


    possible_moves
  end

end
