#!/usr/local/bin/ruby -w

Thread.abort_on_exception= true

require 'monitor'

$x= 0

def thread1(m, c)
  for i in 1..10000
    m.synchronize() do
      c.wait_while { $x % 2 == 0 }
      local= $x
      local += 1
      $x= local
      puts("i: #{i}")
      c.broadcast()
    end
  end
end

def thread2(m, c)
  for j in 1..10000
    m.synchronize() do
      c.wait_while { $x % 2 == 1 }
      local= $x
      local += 1
      $x= local
      puts("j: #{j}")
      c.broadcast()
    end
  end
end

m= Monitor.new()
c= m.new_cond();

x= Thread.new() { thread1(m, c) }
y= Thread.new() { thread2(m, c) }

x.join()
y.join()

puts($x)
