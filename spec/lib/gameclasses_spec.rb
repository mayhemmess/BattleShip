require 'spec_helper'
require 'gameclasses'
require 'matrix'

describe Board do 

# Start Initialization tests	

it "initialize the board correctly" do
	board = Board.new()
	expect(board.validation).to eql true
end

it "Checks the correctness of the cells" do
	board = Board.new()
	expect(board.validationCell).to eql true
end

it "Checks that the name attribute is set correctly" do
	board = Board.new()
	expect(board.setName("Raul")).to eql "Raul"
end

it "Checks that the name of the Board Player is correct" do
   board = Board.new()
   board.setName("Juan")
   expect(board.getName).to eql "Juan"
end

# End Initialization tests

#Start set command tests

it "Checks that the set command sets the ship correctly" do
  board = Board.new()
  expect(board.putsShips(1,1,"S","V",1)).to eql false
end

it "Checks that the set command doesnt set an invalid location" do
board= Board.new()
expect(board.putsShips(11,11,"S","V",1)).to eql true
end

it "Checks that the set command doesnt set in the first row" do
	board= Board.new()
	expect(board.putsShips(1,0,"S","V",1)).to eql true
end

it "Checks that the set command doesnt set in the first column" do
	board= Board.new()
	expect(board.putsShips(0,10,"S","V",1)).to eql true
end

it "Checks that the set command doesnt set a ship in an occupied cell" do
	board = Board.new()
	board.putsShips(1,1,"S","V",1)
	expect(board.putsShips(1,1,"S","V",1)).to eql true
end


it "Checks that the set command doesnt set a ship too large for the space in a Vertical line" do
board = Board.new()
expect(board.putsShips(9,9,"S","V",4)).to eql true
end

it "Checks that the set command doesnt set a ship too large for the space in an Horizontal line" do
board = Board.new()
expect(board.putsShips(9,9,"S","H",4)).to eql true
end

it "Checks that the set command  doesnt set a ship  in a Vertical line when there is another ship " do
board = Board.new()
board.putsShips(5,5,"S","V",4)
expect(board.putsShips(7,5,"S","V",4)).to eql true
end

it "Checks that the set command  doesnt set a ship  in an Horizontal line when there is another ship " do
board = Board.new()
board.putsShips(5,5,"S","H",4)
expect(board.putsShips(5,8,"S","H",4)).to eql true
end

it "Checks that the set command  sets a ship  in a Vertical line" do
board = Board.new()
board.setName("Raul")
board.putsShips(5,5,"S","V",4)
expect(board.hit(6,5)).to eql "Raul,report,[X],6,5"
end

it "Checks that the set command  sets a ship  in an Horizontal line" do
board = Board.new()
board.setName("Raul")
board.putsShips(5,5,"S","H",4)
expect(board.hit(5,7)).to eql "Raul,report,[X],5,7"
end

it "Checks Hp being increased when a ship is set correctly" do
board = Board.new()
board.putsShips(5,5,"S","H",4)
expect(board.getHP).to eql 4
end

it "Checks hit being increased when a ship is hit" do
board = Board.new()
board.putsShips(5,5,"S","H",4)
board.hit(5,7)
expect(board.getHits).to eql 1
end

it "Checks how many ships have been set  correctly" do
board = Board.new()
board.putsShips(5,5,"S","H",4)
board.putsShips(1,1,"S","H",1)
expect(board.getShips).to eql 2
end

it "Checks that all ships have been set correctly" do
 board = Board.new()
board.putsShips(5,5,"S","H",4)
board.putsShips(1,1,"S","H",1)
board.putsShips(1,2,"S","H",1)
board.putsShips(1,3,"S","H",1)
board.putsShips(1,4,"S","H",1)
expect(board.putsShips(1,1,"S","H",1)).to eql true
end

# Ends set command tests

# Starts Game Over tests
it "Checks winning board changes to all 0s" do
board = Board.new()
board.gameOver("1")
expect(board.getCell(3,3)).to eql "[0]" 
expect(board.getCell(9,9)).to eql "[0]"
expect(board.getCell(0,1)).to eql "[0]"
end


it "Checks losing board changes to all Xs" do
board = Board.new()
board.gameOver("0")
expect(board.getCell(3,3)).to eql "[X]" 
expect(board.getCell(9,9)).to eql "[X]"
expect(board.getCell(0,1)).to eql "[X]"
end


# End Game Over tests

# Starts Hit command tests

it "Checks when the hit command hits an empty space" do
  board = Board.new()
  board.setName("Chucho")
  expect(board.hit(5,7)).to eql "Chucho,report,[0],5,7"

end

it "Checks when the hit command hits a Ship" do
  board = Board.new()
  board.setName("Chucho")
  board.putsShips(5,5,"S","H",4)
expect(board.hit(5,5)).to eql "Chucho,report,[X],5,5"

end

it "Checks when the last ship has been destroyed" do
	board = Board.new()
  board.setName("Chucho")
  board.putsShips(5,5,"S","H",1)
expect(board.hit(5,5)).to eql "Chucho,death"
end

# Ends hit command tests

end 



