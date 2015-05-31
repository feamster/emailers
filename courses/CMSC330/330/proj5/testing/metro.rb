###############################################################################
### CMSC330 Project 5: Multi-threaded Train Simulation                      ###
### Source code: metro.rb                                                   ###
### Description: A multi-threaded Ruby program that simulates               ###
###              the Washington Metro by creating Train and Person threads  ###
###############################################################################

require "monitor"
Thread.abort_on_exception= true   # to avoid hiding errors in threads 

$lines= {}
$numTrains= {}
$passengers= {}
$simMonitor= {}

$stations= { }

$SimMonitor= { } 
$PassengerCondVar= { } 
$TrainCondVar= { } 

$passengerWaiting= true
$simLimit= 1
$passengerLimit= 1


#----------------------------------------------------------------
# Station 
#----------------------------------------------------------------

class Station
  def initialize (name)
    @name= name
    @train= {}
    $lines.each_key { |k|	
      @train[k]= nil
    }
  end
  
  def to_s
    @name
  end
  
  def train (color)
    @train[color]
  end
  
  def enter (tr)
    if @train[tr.color] != nil
      puts "% ERROR: train #{tr} entering occupied station #{@name}"
    end
    @train[tr.color]= tr
  end
  
  def leave (tr)
    if (tr != @train[tr.color])
      puts "% ERROR: departing #{tr} not at station #{@name} " 
      $stdout.flush
    end
    @train[tr.color]= nil
  end
end

#----------------------------------------------------------------
# Train 
#----------------------------------------------------------------

class Train

  def initialize (color, num, limit)
    @color= color
    @num= num
    @limit= limit+1
    @numPassengers= 0
    
    @stops= $lines[color]
    @stopIdx= 0
    @direction= 1 # 1 or -1
    @station= nil
  end

  def to_s
    "#{@color} #{@num}"
  end
  
  def color
    @color
  end
  
  def direction
    @direction
  end

  def station
    @station
  end
  
  def addPassenger
    @numPassengers += 1
  end
  
  def removePassenger
    @numPassengers -= 1
  end
  
  def numPassengers
    @numPassengers
  end
  
  def move() 
    while ($passengerWaiting || @limit > 0) do
      curStation= $stations[@stops[@stopIdx]]

      $SimMonitor[color].synchronize {
        $TrainCondVar[@color].wait_until { curStation.train(color) == nil}
        curStation.enter(self)
        @station= curStation
        puts "Train #{self} entering #{curStation}"
        $stdout.flush
        $PassengerCondVar[@color].broadcast
      }

      sleep 0.01
      
      $SimMonitor[color].synchronize {
        curStation.leave(self)
        @station= nil
        puts "Train #{self} leaving #{curStation}"
        $stdout.flush
        $TrainCondVar[@color].broadcast
      }

      @limit= @limit -1 if (@stopIdx == 0)
      @stopIdx += @direction
      @direction *= -1 if (@stopIdx == 0) || (@stopIdx == (@stops.length - 1))
    end 
  end
end

#----------------------------------------------------------------
# Passenger 
#----------------------------------------------------------------

class Passenger
  def initialize(name, stops)
    @name= name
    @stops= stops
    @stopIdx= 0
    @train= nil
    @line= nil
    setLine
  end

  def setLine
    curStop= @stops[@stopIdx]
    nextStop= @stops[@stopIdx+1]
    @line= findLine(curStop, nextStop)
  end
  
  def findLine (st1, st2)
    $lines.each { |color, stops|
      return color if stops.include?(st1) && stops.include?(st2)
    }
    puts "% ERROR: #{st1} #{st2} not on same line"
    return nil
  end

  def to_s
    @name
  end
  
  def boardTrain
    puts "% Error: boardTrain already on train" if @train != nil
    curStation= @stops[@stopIdx]
    color= @line
    st= $stations[curStation]
    #@train= st.train(color) 
    $SimMonitor[color].synchronize {  # lah- nil test added
      $PassengerCondVar[color].wait_until { (st.train(color) != nil && \
        @train= st.train(color)) && \
        #!(puts "YOOOOOOOOOOOO: #{@train.numPassengers}") && \
        @train.numPassengers < $passengerLimit }
      @train.addPassenger
      puts "#{@name} boarding train #{@train} at #{st}"
      $stdout.flush
    }
  end
  
  def leaveTrain
    puts "% Error: leaveTrain not on train" if @train == nil
    @stopIdx += 1
    color= @line
    destStation= $stations[@stops[@stopIdx]]					
    $SimMonitor[color].synchronize {
      $PassengerCondVar[color].wait_until { @train.station == destStation  }
      puts "#{@name} leaving train #{@train} at #{destStation}"
      @train.removePassenger
      @train= nil
      $stdout.flush
    }

  end
  
  def ride 
    # puts "Passenger #{@name} on line #{@line}"
    while @stopIdx != @stops.length-1 do
      sleep 0.01
      setLine
      boardTrain
      leaveTrain
    end
  end
  
end

#----------------------------------------------------------------
# Metro Simulator
#----------------------------------------------------------------

def simulate(lines,numTrains,passengers,simMonitor, passengerLimit)
  $lines= lines
  $numTrains= numTrains
  $passengers= passengers
  $SimMonitor= simMonitor
  $passengerLimit= passengerLimit

  $lines.each { |k,v|		
    $TrainCondVar[k]= $SimMonitor[k].new_cond
    $PassengerCondVar[k]= $SimMonitor[k].new_cond
    
    v.each { |s| 
      $stations[s]= Station.new(s) if $stations[s] == nil
      
    }
  }

  trainThreads= []
  allTrains= {}
  passengerThreads= []
  
  $lines.each_key { |color|
    trainNum= 1
    (1..$numTrains[color]).each { |n|
      train= Train.new(color,trainNum,$simLimit)
      allTrains[train]= trainNum
      trainNum += 1
    }
  }
  
  # create threads for passengers
  $passengers.each { |name, stops|
    p= Passenger.new(name, stops)
    thread= Thread.new do p.ride end
    passengerThreads.push(thread)
  }
  $passengerWait= false if passengerThreads.length == 0

  # create threads for trains 
  allTrains.each_key { |t|
    thread= Thread.new do t.move() end
    trainThreads.push(thread)
  }

  # so that main thread will wait until all passenger threads finish
  passengerThreads.each { |t| t.join }
  sleep 0.0001
  $passengerWaiting= false
  
  # if no passengers, wait for trains to terminate on their own
  trainThreads.each { |t| t.join } if passengerThreads.length == 0

end

#----------------------------------------------------------------
# Simulation Display
#----------------------------------------------------------------

def displayState(lines,stations,trains)
  lines.keys.sort.each { |color|
    stops= lines[color]
    puts color
    stops.each { |stop| 
      pStr= ""
      tStr= ""
      
      stations[stop]["passenger"].keys.sort.each { |passenger|
        pStr << passenger << " "
      }
      
      stations[stop][color].keys.sort.each { |trainNum| 
        tr= color+" "+trainNum
        tStr << "[" << tr
        if trains[tr] != nil
          trains[tr].keys.sort.each { |p|
            tStr << " " << p
          }
        end
        tStr << "]"
      }
      
      printf("  %25s %10s %-10s\n", stop, pStr, tStr)
    }	
  }
  puts 

end

def display(lines,passengers,output)
  
  $lines= lines
  $passengers= passengers
  
  stations= {}
  $lines.each { |k,v|		
    v.each { |s| 
      stations[s]= { } if stations[s] == nil
      stations[s]["passenger"]= { }
      $lines.each_key { |k|	
        stations[s][k]= { }
      }
    }
  }
  trains= {}

  # add passengers to stations before trains start
  passengers.each { |name,list|
    startingLoc= list[0]
    stations[startingLoc]["passenger"][name]= 0
  }
  
  time= 1
  displayState(lines,stations,trains)
  output.each {|o|
    puts o
    if o =~ /^Train ([A-Za-z]+) ([0-9]+) (enter|leav)ing (.+)$/
      color= $1; 
      num= $2;
      action= $3; 
      station= $4
      tr= color+" "+num
      trains[tr]= {} if trains[tr] == nil
      if (action == "enter")
        stations[station][color][num]= time
      else 
        stations[station][color].delete(num)
      end
      
    elsif o =~ /^(.+) (board|leav)ing train ([A-Za-z]+) ([0-9]+) at (.+)$/
      passenger= $1; 
      action= $2;
      color= $3; 
      num= $4;
      station= $5
      tr= color+" "+num
      if (action == "board")
        stations[station]["passenger"].delete(passenger)
        trains[tr]= {} if trains[tr] == nil
        trains[tr][passenger]= time
      else 
        trains[tr]= {} if trains[tr] == nil
        stations[station]["passenger"][passenger]= time
        trains[tr].delete(passenger)
      end
    else
      puts "% ERROR Illegal output #{o}"
    end

    displayState(lines,stations,trains)
    time= time + 1
  }

end

#----------------------------------------------------------------
# Simulation Verifier
#----------------------------------------------------------------

def verify(lines,numTrains,passengers,output,limit)
  outputFormat= true
  
  $lines= lines
  $numTrains= numTrains
  $passengers= passengers
  $passengerLimit= limit
  
  stations= {}
  $lines.each { |k,v|		
    v.each { |s| 
      stations[s]= { } if stations[s] == nil
      stations[s]["passenger"]= { }
      $lines.each_key { |k|	
        stations[s][k]= { }
      }
    }
  }
  trains= {}

  # add passengers to stations before trains start
  passengers.each { |name,list|
    startingLoc= list[0]
    stations[startingLoc]["passenger"][name]= 0
  }
  
  trainHist= {}
  passengerHist= {}
  
  time= 1        
  output.each {|o|
    if o =~ /^Train ([A-Za-z]+) ([0-9]+) (enter|leav)ing (.+)$/
      color= $1; 
      num= $2;
      action= $3; 
      station= $4
      tr= color+" "+num
      trains[tr]= {} if trains[tr] == nil
      if (action == "enter")
        stations[station][color][num]= time
        if stations[station][color].length > 1
          puts "% ERROR: #{tr} entering occupied station #{station}"
          outputFormat= false
        end
        if trainHist[tr] == nil
          trainHist[tr]= [color]
          st2= lines[color][0]
          if station != st2
            puts "% ERROR: #{tr} not starting from #{st2}"
            outputFormat= false
          end
        end
        idx1= lines[color].index(station)
        if idx1 == nil
          puts "% ERROR: #{tr} entering illegal station #{station}"
          outputFormat= false
        end
        idx2= nil
        idx2= lines[color].index(trainHist[tr].last) if trainHist[tr].length > 0
        if idx1 != nil && idx2 != nil && (idx1 - idx2).abs > 1
          puts "% ERROR: Train #{tr} jumping to station #{station}"
          outputFormat= false
        end
        trainHist[tr].push station
      else 
        stations[station][color].delete(num)
        if trainHist[tr] == nil
          trainHist[tr]= [color] 
          puts "% ERROR: #{tr} leaving station #{station} before entering" 
          outputFormat= false
        end
        if trainHist[tr].last != station
          puts "% ERROR: #{tr} leaving station #{station} before entering" 
          outputFormat= false
        end
      end
      
    elsif o =~ /^(.+) (board|leav)ing train ([A-Za-z]+) ([0-9]+) at (.+)$/
      passenger= $1; 
      action= $2;
      color= $3; 
      num= $4;
      station= $5
      tr= color+" "+num
      if (action == "board")
        if stations[station]["passenger"] == nil
          puts "% ERROR: #{passenger} illegally boarding #{tr} at station #{station}"
          outputFormat= false
        end
        stations[station]["passenger"].delete(passenger)
        trains[tr]= {} if trains[tr] == nil
        trains[tr][passenger]= time
        if trains[tr].values.size > $passengerLimit
          puts "% ERROR: Train #{tr} exceeded maximum number of passengers."
          outputFormat= false
        end
        if stations[station][color][num] == nil
          puts "% ERROR: #{passenger} illegally boarding #{tr} at station #{station}"
          outputFormat= false
        end
        passengerHist[passenger]= [] if passengerHist[passenger] == nil
        passengerHist[passenger].push(station) if passengerHist[passenger].last != station
      else 
        trains[tr]= {} if trains[tr] == nil
        if trains[tr][passenger] == nil
          puts "% ERROR: #{passenger} illegally leaving #{tr} at station #{station}"
          outputFormat= false
        end
        stations[station]["passenger"][passenger]= time
        trains[tr].delete(passenger)
        if stations[station][color][num] == nil
          puts "% ERROR: #{passenger} illegally leaving #{tr} at station #{station}"
          outputFormat= false
        end
        passengerHist[passenger]= [] if passengerHist[passenger] == nil
        passengerHist[passenger].push(station) if passengerHist[passenger].last != station
      end
    else
      puts "% ERROR Illegal output #{o}"
      outputFormat= false
    end
    time= time + 1
  }

  # check passenger path
  passengers.each { |p,a|
    hist= passengerHist[p]
    if (hist == nil) || hist.last != a.last
      puts "% ERROR: #{p} did not reach destination"
      outputFormat= false
    else
      for i in 0..a.length-1 do
        st= hist.shift
        if a[i] != st
          puts "% ERROR: #{p} left path at #{st}"
          outputFormat= false
        end
      end
    end
  }
  
  # check train path
  trainHist.each { |t,path|
    color= path.shift
    stops= lines[color]
    stopIdx= 0
    direction= 1
    for i in 0..path.length-1 do
      if path[i] != stops[stopIdx]
        puts "% ERROR: #{t} left path at #{stops[stopIdx]}" 
        outputFormat= false
      end
      stopIdx += direction
      direction *= -1 if (stopIdx == 0) || (stopIdx == (stops.length - 1))
    end
    
    # if no passengers, check all trains make at least one round trip
    if (passengerHist.length) == 0 && (path.length < ((2 * lines[color].length) - 1))
      puts "% ERROR: #{t} failed to make at least one round trip" 
      outputFormat= false
    end
  }
  
  # check all trains appear
  numTrains.each { |color, num|
    for i in 1..num do
      if trainHist[color+" "+i.to_s] == nil
        puts "% ERROR: no sign of train #{color} #{i}"
        outputFormat= false
      end
    end
  }
  
  return outputFormat
end
