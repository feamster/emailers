#!/usr/bin/ruby

if (File.exist?("/usr/bin/ruby1.9.1"))
  executable= "/usr/bin/ruby1.9.1"
else
  executable= "/usr/bin/ruby"
end

# Dir["public?.input", "secret??.input"].sort().each() { |test|
`ls public?.input secret??.input`.split().sort().each() { |test|

  puts("#{test}\n")

  output_file_name= "#{test.split('.')[0]}.output"

  if (test == "secret01.input") then
    args= "-n"
  elsif (test == "secret02.input") then
    args= "n -m -no"
  else
    args= ""
  end

  system("#{executable} proj1.rb #{args} < #{test} > #{output_file_name}")
}
