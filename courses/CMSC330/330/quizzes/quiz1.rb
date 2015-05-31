#!/usr/local/bin/ruby -w

x= Hash.new()
y= [1, 3, 5, 7, 9, 11]

4.upto(9) { |z|
  x[z]= y[0]
  y.delete_at(0)
}

x.keys().sort().each() { |key|
  puts("#{key} -> #{x[key]}")
}

puts("")

x.values().sort().each() { |value|
  if (x[value] != nil) then
    puts("#{value} -> #{x[value]}")
  end
}
