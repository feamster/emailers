#!/usr/local/bin/ruby -w

# Run this program before looking at the code.  It illustrates different
# ways to write loops, but the code is written using eval, which runs Ruby
# code from a string.  Multiline strings use the << construction.

puts("There are many ways to write a loop in Ruby. This program will " +
     "show some.\n\n")

def show_loop(l)
  puts("Code:")
  puts(l, "\n")

  print("Result:\n")
  eval(l)
  puts("\n\n-----------\n\n")
end

show_loop("5.times() {|i| print i}\n")

show_loop <<LOOP
5.times() do |i|
  print(i)
end
LOOP

show_loop("0.upto(4) {|i| print i}\n")

show_loop <<LOOP
for i in (0..4)
  print(i)
end
LOOP

show_loop("(0..4).each() {|i| print(i)}\n")

show_loop <<LOOP
i= -1
print i += 1 while (i < 4)
LOOP

show_loop <<LOOP
i= -1
print i += 1 until (i == 4)
LOOP

show_loop <<LOOP
i= 0
while i < 5 do
  print(i)
  i += 1
end
LOOP

show_loop <<LOOP
i=0
loop do
  print(i)
  break if (i += 1) == 5
end
LOOP
