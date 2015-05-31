#!/usr/local/bin/ruby -w

def count_aa(filename)
  file = File.new(filename, "r")
  lines = file.readlines()
  counts = Hash.new()

  lines.each() { |line|
    acids = line.scan(/.../)
    acids.each() { |aa|
      if (counts[aa] == nil)
        counts[aa] = 1
      else
        counts[aa] += 1
      end
    }
  }

  return counts
end

result = count_aa("amino-acid-input")

pairs= Array.new()

result.keys().each() { |acid|       # sorting here not necessary
  pairs.push([result[acid], acid])  # add two-element array
}

pairs.sort() { |a, b|
  (b[0] <=> a[0]) != 0 ? -(a[0] <=> b[0]) : a[1] <=> b[1]
}.each() { |occurrences, acid_name|
  puts("#{acid_name} #{occurrences}")
}
