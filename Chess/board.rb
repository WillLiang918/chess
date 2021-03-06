require_relative 'piece'
require 'byebug'

class Board
  attr_accessor :grid, :white_king, :black_king, :white_pieces, :black_pieces,
                :current_piece, :old_position, :new_position, :replaced_piece, :current_turn

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @white_pieces = []
    @black_pieces = []
    populate_board

    @previous = nil
    @current_turn = :black
  end

  def move(start, end_pos)
    raise ArgumentError.new("No piece was selected") if self[start].nil?
    raise ArgumentError.new("This is not a valid move") unless valid_move?(start, end_pos)

    # Only swapping pieces not taking
    self[start], self[end_pos] = self[end_pos], self[start]

    true
  end

  def in_check?(color)
    if color == :black
      self.white_pieces.each do |piece|
        current_moves = piece.moves
        return true if current_moves.include?(self.black_king.pos)
      end

    else
      self.black_pieces.each do |piece|
        current_moves = piece.moves
        return true if current_moves.include?(self.white_king.pos)
      end
    end

    false
  end

  def checkmate?(color)
    return false unless self.in_check?(color)
    self.white_pieces.each do |piece|

      current_moves = piece.moves
      current_moves.each do |move|

        temp_board_update(self, move, piece)
        if !self.in_check?(color)
          self.undo
          return false
        end
        self.undo
      end
    end
    true
  end

  def temp_board_update(board, move, piece)
    @current_piece = piece
    @old_position = piece.pos
    @new_position = move
    if board[move].nil?
      @replaced_piece = nil
    else
      @replaced_piece = board[move]
    end

    board[move] = piece
    board[piece.pos] = nil
  end

  def undo
    self[self.old_position] = self.current_piece
    self[self.new_position] = self.replaced_piece
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
      next if i == 3 || i == 4
      new_pawn = create_new_piece([1, i], :p)
      self[[1, i]] = new_pawn
      self.white_pieces << new_pawn
    end
    @grid[6].each_index do |i|
      new_pawn = create_new_piece([6, i], :p, :black)
      self[[6, i]] = new_pawn
      self.black_pieces << new_pawn
    end
  end

  def create_back_rows
    [:r, :h, :b, :q, :k, :b, :h, :r].each_with_index do |piece, i|

      new_piece = create_new_piece([0, i], piece)
      self[[0, i]] = new_piece
      self.white_pieces << new_piece

      nnew_piece = create_new_piece([7, i], piece, :black)
      self[[7, i]] = new_piece
      self.black_pieces << new_piece
    end
  end

  def create_new_piece(pos, symbol, color = :white)
    case symbol
    when :r
      Rook.new(pos, self, symbol, color)
    when :b
      Bishop.new(pos, self, symbol, color)
    when :q
      Queen.new(pos, self, symbol, color)
    when :h
      Knight.new(pos, self, symbol, color)
    when :k
      if color == :black
        self.black_king = King.new(pos, self, symbol, color)
      else
        self.white_king = King.new(pos, self, symbol, color)
      end
    when :p
      Pawn.new(pos, self, symbol, color)
    end
  end
end
