require 'matrix'
require 'sessions_helper.rb'
###GameClasses.Rb
##Classfile for Matrix, Board, and EventDispatcher



###Matrix
##Simple function changes for easier matrix use.
class Matrix
  #[]
  #Allows easier setting of the values of a specific Matrix spot
  def []= (row, column, value)
  @rows[row][column] = value
  end
end

###Board
##Each player has his or her own board as well as a board representing the
##opponent's board.
##A player's Board displays where their ships are, and an enemie's Board 
##represents places where the player has attacked.
class Board

  ##initialize
  #By default boards have the first column and row as number 1-10
  #and every space is empty with "[-]"
  def initialize()
    @board = Matrix.build(11,11) {|row, col| "[-]"}
    for i in 1..10
      @board[0,i] = "[#{i}]"
      @board[i,0] = "[#{i}]"
    end
    @hits = 0
    @hp = 0
    @ships = 0
    @name= "?"
  end
  
  ##setName
  #Basic set function for the name variable
  def setName(name)
    @name = name.to_s
  end

  ##getName
  #Basic get function for the name variable
  def getName()
    return @name
  end

  ##hit
  #Reieves an x and a y coordinate.
  #Checks to see if the space that matches those coordinates is ocupied
  #by a ship. If it is, the function report a "[X]", signifing a hit.
  #Anything else, returns a "[0]", indicating a miss.
  #If the hit connects and it is the last remaining Ship space,
  #hit returns "@name,death", signifing the end of the game.
  def hit(x, y)
    x = x.to_i
    y = y.to_i
    if @board[x,y] == "[-]" || @board[x,y] =="[X]"
      @board[x,y] = "[0]"
      return "#{@name},report,[0],#{x},#{y}"
    else
      @board[x,y] = "[X]"
      @hits = @hits + 1
      if(@hits == @hp)
        return "#{@name},death"
      end
      return "#{@name},report,[X],#{x},#{y}"
    end
  end

  ##printAll
  #Turns the board into an array for easier printing.
  def printAll()
    arrenglones = []
    for i in 0..11
      renglon ="" 
      for j in 0..11
        renglon = renglon.to_s + @board[i,j].to_s
      end
      arrenglones[i] = renglon
    end
    return arrenglones
  end

  ##putsShips
  #Function in charge of validating and setting a ship in place.
  #Recieves the following parameters:
  # * x/y = x and y coordinates for the start point of the ship.
  # * n = Name of the ship.
  # * o = Orientation for the ship, V for vertical and H for Horizontal
  # * l = length of the ship.  
  def putsShips(x, y, n, o, l)
    #5 is the maximum number of ships.
    if(@ships==5)
      return true
    end
    l = l.to_i - 1
    x = x.to_i
    y = y.to_i

    #Validate the ship's position.
    if(@board[x.to_i,y.to_i] == "[-]")
    if(o == "V")
        if(x+l >= 11)
          puts "Error, espacio inadecuado"
          return true
        end
        for i in 0..l
          if(@board[i+x,y] != "[-]")
            puts "Espacio ya ocupado"
            return true
          end
        end
      else(o =="H")
        if(y+l >= 11)
          puts "Error, espacio inadecuado"
          return true
        end
        for i in 0..1
          if(@board[x,y+1] != "[-]")
            puts "Espacio ya ocupado"
            return true
          end
        end
      end
    else
      puts "Espacio ya ocupado"
      return true
      end

    #All clear!
    #Set the ship in place
    if(o == "V")
      for i in 0..l
        @hp = @hp + 1
        @board[x+i,y] = "[#{n}]"
      end
    else(o =="H")
      for i in 0..l
        @hp = @hp + 1
        @board[x, y+i] = "[#{n}]"
      end
    end
    @ships = @ships.to_i + 1
    return false
  end

  ##Game Over
  #Reiceves 1 for victory and 0 for failure.
  #If the board is the losing board, set all values to "[X]"
  #If the board won, set "[0]"
  def gameOver(x)
    x = x.to_i
    if(x == 1)
      @board = Matrix.build(11,11) {|row, col| "[0]"}
    end
    if(x == 0)
      @board = Matrix.build(11,11) {|row, col| "[X]"}
    end
  end
end

###SendEvents
##Encompasses all the functions related with reading player input.
class SendEvents
  ##EventDispatch
  ##In charge of recieving the basic input and calling the apropriate function.
  def self.EventDispatch(inst)
    if(inst[0].to_s == GlobalConstants::BOARDB.getName)  
      if(inst[1].to_s == "SetS")
        SetShipEvent(inst, "H")
      elsif(inst[1].to_s == "Hit")
        HitEvent(inst, "H")
      end
    elsif(inst[0].to_s == GlobalConstants::BOARDA.getName)
      if(inst[1].to_s == "SetS")
        SetShipEvent(inst, "M")
      elsif(inst[1].to_s == "Hit")
        HitEvent(inst, "M")
      end
    end
  end

  ##SetShipEvent
  ##Gets the global boards and attempts to put ships in them.
  def self.SetShipEvent(inst, who)
    if(who.to_s == "H")
      GlobalConstants::BOARDB.putsShips(inst[2].to_i, inst[3].to_i, inst[4].to_s, inst[5].to_s, inst[6].to_i)
    elsif(who.to_s == "M")
      GlobalConstants::BOARDA.putsShips(inst[2].to_i, inst[3].to_i, inst[4].to_s, inst[5].to_s, inst[6].to_i)
    end
  end

  ##HitEvent
  #Sends a hit for a player.
  #If the hit is a KO, ends the game.
  def self.HitEvent(inst, who)
    if(who.to_s == "H")
      result= GlobalConstants::BOARDA.hit(inst[2].to_s, inst[3].to_s)
      res = result.split(",")
      if(res[1].to_s == "death")
        winner = GlobalConstants::BOARDB.getName
        loser = GlobalConstants::BOARDA.getName
        userW =  User.find_by_name(winner)
        
        userW.win = userW.win + 1
        userW.save
        
        userL =  User.find_by_name(loser)
        userL.lose= userL.lose + 1
        userL.save

        GlobalConstants::BOARDAAUX.gameOver(0)
        GlobalConstants::BOARDBAUX.gameOver(1)
        GlobalConstants::BOARDA.gameOver(1)
        GlobalConstants::BOARDB.gameOver(0)
      else
        Redis.new.publish "chat", result
      end
    elsif(who.to_s =="M")
      result= GlobalConstants::BOARDB.hit(inst[2].to_s, inst[3].to_s)
        res = result.split(",")
        if(res[1].to_s == "death")
        winner = GlobalConstants::BOARDB.getName
        loser = GlobalConstants::BOARDA.getName
        userW =  User.find_by_name(winner)
        userW.win = userW.win + 1
        userW.save


        userL =  User.find_by_name(loser)
        userL.lose= userL.lose + 1
        userL.save
        
        GlobalConstants::BOARDBAUX.gameOver(0)
        GlobalConstants::BOARDAAUX.gameOver(1)
        GlobalConstants::BOARDB.gameOver(1)
        GlobalConstants::BOARDA.gameOver(0)
        else
         Redis.new.publish "chat", result
       end
    end
  end
end