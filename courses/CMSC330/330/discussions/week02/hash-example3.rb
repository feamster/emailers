#!/usr/local/bin/ruby -w

sections= Hash.new()

while (line= gets())

  fields= line.split(' ')                           # one space between fields
  line.rstrip!()
  first_name, last_name, iD, section= fields[0..3]  # assume four fields

  if (sections[section] == nil) then
    sections[section]= Hash.new()
  end

  sections[section][iD]= last_name + ", " + first_name

end

sections.keys().sort().each() { |section|

  puts("#{section}:")

  sections[section].keys().sort().each() { |sid|
    puts("#{sid} #{sections[section][sid]}")
  }

  puts("")

}
