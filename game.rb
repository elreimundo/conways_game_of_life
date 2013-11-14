require_relative 'cell.rb'

class Game
	attr_reader :board
	def initialize(nested_array)
		@board = nested_array.map { |row| row.map{ |cell| Cell.new( cell==1 ) } }
		connect_cells
	end

	def generate!
		cells_to_change.each { |cell| cell.toggle! }
	end

	def cells_to_change
		@board.flatten.inject([]) { |pile, cell| cell.should_change? ? pile + [cell] : pile }
	end

	def connect_cells
		@board.each_index do |x|
			@board[x].each_with_index do |cell, y|
				(-1..1).each do |x_offset|
					(-1..1).each do |y_offset|
						cell.connect_to(@board[x+x_offset][y+y_offset]) if cell_at(x+x_offset, y+y_offset)
					end
				end
			end
		end
	end

	def cell_at(x,y)
		x >= 0 && y >= 0 && @board[x] && @board[x][y]
	end

	def clear?
		@board.flatten.each{|c| return false if c.alive}
		true
	end
end