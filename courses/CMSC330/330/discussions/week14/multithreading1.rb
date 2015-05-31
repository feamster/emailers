#!/usr/local/bin/ruby

require 'monitor'

class Container

  def initialize()
    @buf= nil
    @monitor= Monitor.new
    @cond= @monitor.new_cond()
  end
  
  def produce(x)
    @monitor.synchronize do  # lock
      if (@buf != nil)
        raise("FullException")
      end
      
      @buf= x
    end  # unlock
  end
  
  def consume()
    x= nil
    
    @monitor.synchronize do  # lock
      if (@buf == nil)
        raise("EmptyException")
      end
      
      x= @buf
      @buf= nil
    end  # unlock
    
    return x
  end
  
  def store(x)
    @monitor.synchronize do  # lock
      @cond.wait_while { @buf != nil }
      @buf= x
      @cond.broadcast()
    end  # unlock
  end
  
  def take()
    x= nil
    
    @monitor.synchronize do  # lock
      @cond.wait_while { @buf == nil }
      
      x= @buf
      @buf= nil
      
      @cond.broadcast()
    end  # unlock
    
    return x
  end

end

def act(buffer, action)
  action.each { |x|
    if (x == "consume")
      puts("Consumed #{buffer.take()}.")
      $stdout.flush()
    elsif x == "sleep"
      puts("Sleeping.")
      $stdout.flush()
      sleep(1)
    else
      puts("Producing #{x}.")
      $stdout.flush()
      buffer.store(x)
    end
  }
end

container= Container.new()

t1= Thread.new() {
  act(container, ["sleep", 1, 2, 3])
}

t2= Thread.new() {
  act(container, ["consume"])
}

t3= Thread.new() {
  act(container, ["sleep", "sleep", "consume"])
}

t4= Thread.new() {
  act(container, ["sleep", "sleep", "sleep", "consume"])
}

# Why are these here?  Try the program without them and see.
t1.join()
t2.join()
t3.join()
t4.join()
