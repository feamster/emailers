#!/usr/bin/env ruby

def select(list)
  result= Array.new()
  list.each() { |elt|
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

arr= [-1, 4, 5, -10, 17, -17, 30, 0, -99, 99]

select(arr) { |e| even(e) }.each { |x| print("#{x} ") }
puts()

select(arr) { |e| positive(e) }.each { |x| print("#{x} ") }
puts()
