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

  # find key with maximum value
  max_key= nil
  element_counts.keys().each() { |key|
    if (max_key == nil ||
        element_counts[key] > element_counts[max_key]) then
      max_key= key
    end
  }

  # print the value associated with the largest key
  puts(max_key)

end
