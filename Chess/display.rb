require_relative "board"
require "colorize"
require_relative 'cursorable'
include Cursorable

class Display

  attr_accessor :board, :cursor, :selected, :selected_piece

  def initialize(board)
    @board = board
    @cursor = [0,0]
    @selected_piece = nil
    # @selected = false
  end

  def render
    # system("clear")
    grid = build_grid(self.board)
    grid.each { |row| puts row }
  end

  def build_grid(board)
    grid = []
    board.grid.each_with_index do |row, index|
      grid << build_row(row, index)
    end

    grid
  end

  def build_row(row, idx1)
    new_row = ""
    row.each_with_index do |tile, idx2|
      color_options = colors_for(idx1, idx2)
      if tile.nil?
        new_row << "   ".to_s.colorize(color_options)
      else
        new_row << " #{tile.type} ".to_s.colorize(color_options)
      end
    end
    new_row
  end

  def colors_for(idx1, idx2)
    color_options = { }

    current_piece = self.board[[idx1, idx2]]
    color_options[:color] = current_piece.nil? ? :white : current_piece.color

    if !self.selected_piece.nil? && [idx1, idx2] == self.selected_piece.pos #&& self.selected
      color_options[:background] = :green
    elsif [idx1, idx2] == self.cursor
      color_options[:background] = :light_red
    elsif (idx1 + idx2).odd?
      color_options[:background] = :black
    else
      color_options[:background] = :yellow
    end

    color_options
  end

  def get_keystroke
    keystroke = Cursorable::get_input

    case keystroke
    when :space, :return

      p !self.board[self.cursor].nil?
      p self.selected_piece.nil?

      if !self.board[self.cursor].nil? && self.selected_piece.nil?

        p "1"

        self.selected_piece = self.board[self.cursor]


      elsif !self.selected_piece.nil?
        p "2"

        # temp_piece = selected_piece.dup
        self.board[self.selected_piece.pos] = nil
        self.board[self.cursor] = self.selected_piece

        self.selected_piece = nil
      end

      p "3"
    when :left, :right, :up, :down
      self.cursor = Cursorable::update_pos(Cursorable::MOVES[keystroke], self.cursor, self.board)
    else
      puts keystroke
    end
    p selected_piece
  end
end


b = Board.new
d = Display.new(b)

pos = [2,2]
p b.white_pieces.each { |n| print n.class}
p b.white_pieces.length
# k = King.new(pos, b, :k, :white)
# p k.moves

# b[[1,2]] = nil
# pawn = Pawn.new(pos, b, :p, :black)
# p pawn.moves

d.render

# pos2 = [4,4]
# q = Queen.new(pos2, b, :q, :black)
# bi = Bishop.new(pos, b, :q, :black)
# r = Rook.new(pos, b, :q, :black)
# horse = Knight.new(pos, b, :h, :white)
#
# b[pos] = r
# b[pos2] = q
# d.render
#
# p "Rook: #{r.moves}"
# puts
# p "Queen: #{q.moves}"
# p r.moves.length
# p q.moves.length
#p horse.moves
# p horse.moves.length

#
10.times do
  d.render
  d.get_keystroke
  puts "\n"
end
#
# p d.board.white_king.pos
# p b.black_king.pos
