require_relative "board"
require "colorize"
require_relative 'cursorable'
include Cursorable

class Display

  attr_accessor :board, :cursor, :selected, :selected_pos

  def initialize(board)
    @board = board
    @cursor = [0,0]
    @selected_pos = [0,0]
    @selected = false
  end

  def render
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
      new_row << "   ".to_s.colorize(color_options)
    end
    new_row
  end


  def colors_for(idx1, idx2)
    color_options = { }
    color_options[:color] = :white

    if [idx1, idx2] == self.selected_pos && self.selected
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
    key_stroke = Cursorable::get_input
    handled_key_stroke = Cursorable::handle_key(key_stroke, self.cursor, self.board)
    if handled_key_stroke == self.cursor

      # Set piece to selected?
      self.selected = self.selected ? false : true
      self.selected_pos = handled_key_stroke
    else
      self.cursor = handled_key_stroke
    end
  end
end


a = Board.new
b = Display.new(a)

while true
  b.render
  b.get_keystroke
  puts "\n"
end
