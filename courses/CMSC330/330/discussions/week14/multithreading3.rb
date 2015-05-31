#!/usr/local/bin/ruby

require 'monitor'

class BoundedBuffer

  def initialize(capacity)
    @arr= []
    @capacity= capacity
    @monitor= Monitor.new()
    @consumers_cond= @monitor.new_cond()
    @producers_cond= @monitor.new_cond()
  end
  
  def consume()  # remove element from the array and return it
    element= nil
    
    @monitor.synchronize do  # lock
      @consumers_cond.wait_while { @arr.empty?() }
      element= @arr.shift()  # remove from the front
      @producers_cond.broadcast()
      
      puts "Thread #{Thread.current} has consumed #{element}."
      $stdout.flush()
    end  # unlock
    
    return element
  end
  
  def produce(element)      # add an element to the array
    @monitor.synchronize do # lock
      @producers_cond.wait_until { @arr.length() < @capacity }
      @arr.push(element)    # add to the end
      @consumers_cond.broadcast()
      
      puts "Thread #{Thread.current} has produced #{element}."
      $stdout.flush()
    end  # unlock
  end

end


##########################################################

n= 5
c= 3
consumer_threads= []
producer_threads= []
buffer= BoundedBuffer.new(c)

n.times() do
  consumer_threads.push(Thread.new() do
                          sleep(0.5)
                          buffer.consume()
                        end
                        )
end

n.times() do |i|
  producer_threads.push(Thread.new() do
                          sleep(0.5)
                          buffer.produce(n - i)
                        end
                        )
end

consumer_threads.each() do |t|
  t.join()
end

producer_threads.each() do |t|
  t.join()
end
