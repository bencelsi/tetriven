# University of Washington, Programming Languages, Homework 6, hw6runner.rb

class MyPiece < Piece
	All_My_Pieces = All_Pieces +
		[rotations([[0,0],[-1,0],[-1,1],[0,1],[1,1]]), # thumbs up
		[[[0,0],[-1,0],[1,0],[2,0],[-2,0]],           # longer long
		[[0,0],[0,-1],[0,1],[0,2],[0,-2]]],
		rotations([[0,0],[-1,0],[0,1]])]   		  #elbow 
	
	def self.next_piece (board)
		MyPiece.new(All_My_Pieces.sample, board)
	end
end
	
class MyBoard < Board
	def initialize (game)
		super(game)
		@cheating = false
		@current_block = MyPiece.next_piece(self)
	end
	
	def store_current
		locations = @current_block.current_rotation
		displacement = @current_block.position
		(0..(locations.length-1)).each{|index| 
			current = locations[index];
			@grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
			@current_pos[index]
		}
    remove_filled
    @delay = [@delay - 2, 80].max
	end
	
	def next_piece
		if @cheating
			@current_block = MyPiece.new([[[0,0]]], self)
			@cheating = false
		else
			@current_block = MyPiece.next_piece(self)
		end
		@current_pos = nil
	end
	
	def rotate_upside_down
		if !game_over? and @game.is_running?
			@current_block.move(0, 0, -2)
		end
		draw
	end
	
	def cheat
		if @score > 100 and !@cheating
			@score -= 100
			@cheating = true
		end
	end
end

class MyTetris < Tetris
	def set_board
		@canvas = TetrisCanvas.new
		@board = MyBoard.new(self)
		@canvas.place(@board.block_size * @board.num_rows + 3,
        @board.block_size * @board.num_columns + 6, 24, 80)
		@board.draw 
	end
	
	def key_bindings
		super
		@root.bind('u', proc {@board.rotate_upside_down}) 
		@root.bind('c', proc {@board.cheat}) 		
	end
end

#########################
#########################
       #CHALLENGE#
#########################
#########################

class MyTetrisChallenge < MyTetris
	def set_board
		@canvas = TetrisCanvas.new
		@board = MyBoardChallenge.new(self)
		@canvas.place(@board.block_size * @board.num_rows + 3,
        @board.block_size * @board.num_columns + 6, 24, 80)
		@board.draw 
	end
	
	def buttons
		super
		@score.text(@board.score.to_s(25))
		@score.place(35, 50, 126, 45)    
	end

	def update_score
		@score.text(@board.score.to_s(25))
	end
end

class MyPieceChallenge < MyPiece
	All_My_Pieces_Challenge = [
		rotations([[0, 0], [0, 1], [1, 0], [1, 1]]), 	# boiler island
		rotations([[0,0],[-1,0],[-1,1],[0,1],[1,1]]), 	# temple island
		rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), 	# survey island
		rotations([[-2, -1], [-1, 1], [0, 1], [1, 1],	# jungle island
		[-2,0],[-1,0],[0,0],[1,0],[-1,-1],[0,-1],[1,-1]]),
		[[[0,0]]]]										# prison island

	All_Colors_Challenge = ['Purple', 'Green', 'Orange', 'Red', 'Blue']

	def initialize (number, board)
		super(All_My_Pieces_Challenge[number], board)
		@color = All_Colors_Challenge[number]
	end
	
	def self.next_piece (board)
		MyPieceChallenge.new(rand(5), board)
	end

end

class MyBoardChallenge < MyBoard
	
	def initialize (game)
		super(game)
		@piece_number = rand(5)
		@current_block = MyPieceChallenge.next_piece(self)
	end
	
	def next_piece
		super
		@current_block = MyPieceChallenge.next_piece(self)
	end
	
	def cheat
		print "no cheating!"
	end
end


