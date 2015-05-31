require 'monitor'

Thread.abort_on_exception = true # to avoid hiding errors in threads

class Buffer

  def initialize()
    @buffer= nil
    @empty= true
    @monitor= Monitor.new()
    @condition= @monitor.new_cond()
  end

  def produce(obj)
    @monitor.synchronize() {
      @condition.wait_while { !@empty }
      @empty= false
      @condition.broadcast()
      @buffer= obj
      puts("#{obj} was produced.")
    }
  end

  def consume()
    @monitor.synchronize() {
      @condition.wait_while { @empty }
      @empty= true
      @condition.broadcast()
      puts("#{@buffer} is being consumed.")
      return @buffer
    }
  end

end

buffer= Buffer.new()

p1= Thread.new() {
  1.upto(100) { |i|
    sleep(rand(0.00000001))
    buffer.produce(i)
  }
}

p2= Thread.new() {
  200.upto(300) { |i|
    sleep(rand(0.00000001))
    buffer.produce(i)
  }
}

p3= Thread.new() {
  400.upto(500) { |i|
    sleep(rand(0.00000001))
    buffer.produce(i)
  }
}

c1= Thread.new() {
  100.times {
    sleep(rand(0.00000001))
    k= buffer.consume()
  }
}

c2= Thread.new() {
  100.times {
    sleep(rand(0.00000001))
    k= buffer.consume()
  }
}

p1.join()
p2.join()
p3.join()
c1.join()
c2.join()
