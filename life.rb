require_relative 'game.rb'

class Play
	attr_reader :game
	def initialize(board)
		@game = Game.new(board)
	end

	def render
		clear_screen
		hr = "\u2500" * (@game.board[0].length * 2 - 1)
		display_board = "\u250c"+hr+"\u2510\n"
		display_board += @game.board.map{|row| "\u2502"+row.map{ |cell| cell.alive ? "\u2588" : " "}.join(" ") + "\u2502"}.join("\n")
		puts display_board + "\n\u2514"+hr+"\u2518"
	end

	def clear_screen
		puts "\e[2J\e[f"
	end
end

rows = ARGV[0].to_i || rand(10)+1
cols = ARGV[1].to_i || rand(10)+1
play = Play.new(Array.new(rows){Array.new(cols){rand(2)}})
50.times do
	play.render
	play.game.generate!
	break if play.game.clear?
	sleep(0.5)
end
play.render
