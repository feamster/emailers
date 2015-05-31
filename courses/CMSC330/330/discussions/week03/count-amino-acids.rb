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

result.keys().sort().each() { |acid|
  puts("#{acid}: #{result[acid]}")
}
