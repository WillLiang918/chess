require_relative "board"
require "colorize"

class Display
  attr_accessor :board, :cursor

  def initialize(board)
    @board = board
    @cursor = [0,0]
  end

  def render
    self.board.grid.each do |row|
      print build_row(row)

    end

  end

  def build_row(row)
  end

end


a = Board.new
b = Display.new(a)

b.render
