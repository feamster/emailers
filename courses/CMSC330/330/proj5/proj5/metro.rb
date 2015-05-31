require "monitor"

Thread.abort_on_exception= true   # to avoid hiding errors in threads

#----------------------------------------------------------------
# Metro simulator
#----------------------------------------------------------------

def simulate(lines, num_trains, passengers, sim_monitor, passenger_limit)
  # puts(lines.inspect)
  # puts(num_trains.inspect)
  # puts(passengers.inspect)
  # puts(sim_monitor.inspect)
  # puts(passenger_limit.inspect)

end

#----------------------------------------------------------------
# Simulation display
#----------------------------------------------------------------

# line= hash of line names to array of stops
# stations= hash of station names =>
#                  hashes for each line => hash of trains at station
#               OR hash for "passenger" => hash of passengers at station
# trains= hash of train names => hash of passengers

def display_state(lines, stations, trains)
  lines.keys().sort().each() { |color|
    stops= lines[color]
    puts(color)
    stops.each() { |stop|
      p_str= ""
      t_str= ""

      stations[stop]["passenger"].keys().sort().each() { |passenger|
        p_str << passenger << " "
      }

      stations[stop][color].keys().sort().each() { |train_num|
        tr= color + " " + train_num
        t_str << "[" << tr
        if (trains[tr] != nil)
          trains[tr].keys().sort().each() { |p|
            t_str << " " << p
          }
        end
        t_str << "]"
      }

      printf("  %25s %10s %-10s\n", stop, p_str, t_str)
    }	
  }
  puts()
end

def display(lines, passengers, output)
  # puts(lines.inspect)
  # puts(passengers.inspect)
  # puts(output.inspect)

  stations= {}
  trains= {}
  output.each {|o|
    puts(o)
    display_state(lines, stations, trains)
  }
end

#----------------------------------------------------------------
# Simulation verifier
#----------------------------------------------------------------

def verify(lines, num_trains, passengers, output, passenger_limit)
  # puts(lines.inspect)
  # puts(num_trains.inspect)
  # puts(passengers.inspect)
  # puts(output.inspect)
  # puts(passenger_limit.inspect)

  # return false
  return true
end
