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
  end

  def render
    system("clear")
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

      if !self.board[self.cursor].nil? && self.selected_piece.nil?
        self.selected_piece = self.board[self.cursor]

      elsif !self.selected_piece.nil?
        self.board[self.selected_piece.pos] = nil
        self.board[self.cursor] = self.selected_piece

        self.selected_piece = nil
      end

    when :left, :right, :up, :down
      self.cursor = Cursorable::update_pos(Cursorable::MOVES[keystroke], self.cursor, self.board)
    else
      puts keystroke
    end
    p selected_piece
  end
end
