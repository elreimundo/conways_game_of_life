require_relative 'life.rb'

describe Cell do
	before(:all) do
		@cell = Cell.new
		@cell_to_die = Cell.new(true, Array.new(4){Cell.new(true)} + Array.new(3){Cell.new(false)})
		@cell_to_grow = Cell.new(false, Array.new(3){Cell.new(true)} + Array.new(3){Cell.new(false)})
		@stable_cell = Cell.new(true, Array.new(2){Cell.new(true)} + Array.new(2){Cell.new(false)})
	end

	it "should say whether or not it is alive" do
	  expect(@cell.alive).to be(false)
	  expect(@cell_to_die.alive).to be(true)
  end

  it "should change state on toggle!" do
  	@cell.toggle!
  	expect(@cell.alive).to be(true)
  	@cell.toggle!
  	expect(@cell.alive).to be(false)
  end

  it "should properly calculate number of living neighbors" do
  	expect(@cell_to_die.number_of_living_neighbors).to eq(4)
  	expect(@cell_to_grow.number_of_living_neighbors).to eq(3)
  end

  it "should know if it needs to die from overcrowding" do
  	expect(@cell_to_die.should_change?).to be(true)
  	expect(@stable_cell.should_change?).to be(false)
  	expect(@cell.should_change?).to be(false) #cell is already dead
  end

  it "should know if it needs to die from underpopulation" do
  	@cell.toggle! #cell has no neighbors but is dead; turn it on and check
  	expect(@cell.should_change?).to be(true)
  	@cell.toggle!
  end

  it "should know if it needs to grow" do
  	expect(@cell_to_grow.should_change?).to be(true)
  	expect(@stable_cell.should_change?).to be(false) #cell is already alive
  end

  it "should allow cells to connect" do
  	@cell.connect_to(@stable_cell)
  	expect(@cell.neighbors).to include(@stable_cell)
  	expect(@stable_cell.neighbors).to include(@cell)
  end
end

describe Game do
	it "should be created with a valid array of bits" do
		expect{ Game.new(Array.new(rand(10)+1){Array.new(rand(10)+1){rand(2)}}) }.not_to raise_error
	end

	it "should not find any cells to change on a stable board" do
		@game = Game.new([[1,1],[1,1]])
		expect(@game.cells_to_change).to be_empty
	end

	it "should not change a stable board on new generation" do
		@game = Game.new([[1,1],[1,1]])
		@cell = @game.board[rand(2)][rand(2)]
		@living = @cell.alive
		@game.generate!
		expect(@living).to eq(@cell.alive)
	end

	it "should find cells to change in an unstable board" do
	@game = Game.new([[1,1],[1,0]])
		expect(@game.cells_to_change.length).to be > 0
	end

	it "should change an unstable board on new generation" do
		@game = Game.new([[1,1],[1,0]])
		expect(@game.board[1][1].alive).to be(false)
		@game.generate!
		expect(@game.board[1][1].alive).to be(true)
	end

	it "should know if the board is empty" do
		expect(Game.new(Array.new(rand(10+1)){Array.new(rand(10)+1,0)}).clear?).to be(true)
	end
end