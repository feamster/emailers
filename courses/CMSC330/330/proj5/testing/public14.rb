#!/usr/local/bin/ruby

test_number= "02"

#
# to make things easy this method is just duplicated from simulate.rb
#
$sim_file_headers= ["=== Lines ===", "=== Trains ===", "=== Passengers ===",
                    "=== Output ===", "=== Passenger Limit ===" ]

def read_params(fname, lines, num_trains, passengers, sim_out, limit)
  begin
    f= File.open(fname)
  rescue Exception => e
    puts(e)
    exit(-1)
  end

  header_lines= $sim_file_headers[0]
  header_trains= $sim_file_headers[1]
  header_passenger= $sim_file_headers[2]
  header_output= $sim_file_headers[3]
  header_passenger_limit= $sim_file_headers[4]

  section= nil
  line_number= 1
  f.each_line() { |line|

    line.chomp!().strip!()

    # skip blank lines and lines beginning with %
    if (line != "" && line !~ /^%/) then

      if (line == header_lines || line == header_trains ||
          line == header_passenger || line == header_output ||
          line == header_passenger_limit)
        section= line
      elsif (section == header_lines)
        parts= line.split(',')
        color= parts.shift().strip()
        stations= []
        parts.each() { |s| stations.push(s.strip!()) }
        lines[color]= stations
      elsif (section == header_trains)
        parts= line.split('=')
        color= parts.shift().strip()
        num_trains[color]= parts[0].to_i()
      elsif (section == header_passenger_limit)
        parts= line.split('=')
        limit << parts[1].to_i()
      elsif (section == header_passenger)
        parts= line.split(',')
        name= parts.shift().strip()
        stations= []
        parts.each() { |s| stations.push(s.strip!()) }
        passengers[name]= stations
      elsif (section == header_output)
        sim_out.push(line)
      else
        puts("Error: simulate file format error in line #{line_number}:\n" +
             "'#{line}'")
        exit(-1)
      end

      line_number += 1

    end  # if (line != "" && line =~ /^%/)
  }
end

def read_output(filename, sim_out)
  lines= {}
  num_trains= {}
  passengers= {}
  limit= []
  read_params(filename, lines, num_trains, passengers, sim_out, limit)
end

#
# to make things easy this method is just duplicated from metro.rb
#
def verify(lines, numTrains, passengers, output, limit)
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

#############################################################################

# run (simulate) program
system("./run-ruby-program #{test_number}")

lines= {}
num_trains= {}
limit= []
passengers= {}
sim_out= []

read_params("public#{test_number}.input", lines, num_trains, passengers,
             sim_out, limit)

limit= limit[0]  # we read limit into an array, but we need its value

sim_out= []
read_output("output", sim_out)

if (!verify(lines, num_trains, passengers, sim_out, limit)) then
  puts("Simulation on public#{test_number}.input FAILED.")
  exit(-1)
else
  puts("Simulation on public#{test_number}.input passed.")
  exit(0)
end
