#!/usr/bin/env ruby

#
# In this version, select is added to the Array class, which students
# weren't taught how to do....
#

def Array.select(list)
  result= Array.new
  list.each { |elt|
    if (yield(elt)) then
      result.push(elt)
    end
  }
  return result
end

def even(x)
  return x % 2 == 0
end

def positive(x)
  return x > 0
end

arr= [1, 2, 1, 8, 2, 0, 5]

arr.select { |e| even(e) }.each { |x| print("#{x} ") }
puts()

arr.select { |e| positive(e) }.each { |x| print("#{x} ") }
puts()
