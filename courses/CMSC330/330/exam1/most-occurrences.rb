#!/usr/local/bin/ruby

list= gets()

if (list !~ /\[(\d+(;\d+)*)\]/) then
  puts("Invalid list.")
else

  # build hash mapping values to their number of occurrences in the list
  elements= $1
  element_counts= Hash.new()
  # or use elements.split(';').each() { |elt|
  elements.scan(/\d+/).each() { |elt|
    element_counts[elt]= 0 if (element_counts[elt] == nil)
    element_counts[elt] += 1
  }

  # invert hash
  reverse= Hash.new()
  element_counts.keys().each() { |key|
    reverse[element_counts[key]]= key
  }

  # print the value associated with the largest key, using Array.max()
  puts("#{reverse[reverse.keys().max()]}")

end
