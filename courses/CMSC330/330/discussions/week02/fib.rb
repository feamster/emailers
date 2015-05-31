#!/usr/local/bin/ruby -w

puts("Usage: fib.rb n1 [n2...]") if ARGV.empty?()

# returns the n'th fibonacci number
def fib(n)
  a, b = 0, 1

  n.times() do
    a, b = b, a + b
  end

  return a
end

ARGV.each() do |n|
  puts("The " + n + "th Fibonacci number is " + fib(n.to_i()).to_s() + ".")
end
