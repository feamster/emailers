#!/usr/bin/ruby -w

require "monitor.rb"

$l= Monitor.new()
$c= $l.new_cond()
$ready= false
$buf= nil

def produce(o)
  $l.synchronize {
    puts("In produce.")
    $stdout.flush()
    $c.wait_while { $ready }
    $buf= o
    $ready= true
    $c.broadcast()
  }
end

def consume()
  temp= nil
  $l.synchronize {
    puts("In consume.")
    $stdout.flush()
    $c.wait_while { !$ready }
    temp= $buf
    $ready= false
    $c.broadcast()
  }
  temp  # return value
end

def act(action)
  action.each { |x|
    if (x == "consume")
      puts("Consumed #{consume()}.")
      $stdout.flush()
    elsif x == "sleep"
      puts("Sleeping.")
      $stdout.flush()
      sleep(1)
    else
      puts("Producing #{x}.")
      $stdout.flush()
      produce(x)
    end
  }
end

t1= Thread.new() {
  act(["sleep", 1, 2, 3])
}

t2= Thread.new() {
  act(["consume"])
}

t3= Thread.new() {
  act(["sleep", "sleep", "consume"])
}

t4= Thread.new() {
  act(["sleep", "sleep", "sleep", "consume"])
}

# Why are these here?  Try the program without them and see.
t1.join()
t2.join()
t3.join()
t4.join()
