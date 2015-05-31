#!/usr/local/bin/ruby -w

students= Hash.new()

while (line= gets())

  fields= line.split(' ')                  # assume one space between fields
  line.rstrip!()
  first_name, last_name, iD= fields[0..2]  # assume there are three fields
  students["#{last_name}, #{first_name}"] = iD

end

students.keys().sort().each() { |name|
  puts("#{name} #{students[name]}")
}
