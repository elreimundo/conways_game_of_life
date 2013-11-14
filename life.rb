class Cell
	attr_reader :alive, :neighbors
	def initialize(alive = false, neighbors = [])
		@alive = alive
		@neighbors = neighbors
	end

	def connect_to(cell)
		return if cell == self || @neighbors.include?(cell)
		@neighbors.push(cell); cell.neighbors.push(self)
	end

	def toggle!
		@alive = !@alive
	end

	def number_of_living_neighbors
		@neighbors.inject(0){|count, cell| cell.alive ? count + 1 : count }
	end

	def should_change?
		return true if alive && (number_of_living_neighbors > 3 || number_of_living_neighbors < 2)
		return true if !alive && number_of_living_neighbors == 3
		false
	end
end
