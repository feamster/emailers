#!/usr/bin/ruby

if (File.exist?("/usr/bin/ruby1.9.1"))
  executable= "/usr/bin/ruby1.9.1"
else
  executable= "/usr/bin/ruby"
end

# Dir["public?.input", "secret??.input"].sort().each() { |test|
`ls public?.input secret??.input`.split().sort().each() { |test|

  puts("#{test}\n")
  test.length().times().each() {
    print('=')
  }
  puts("")

  output_file_name= "#{test.split('.')[0]}.output"

  if (test == "secret01.input") then
    args= "-n"
  elsif (test == "secret02.input") then
    args= "n -m -no"
  else
    args= ""
  end

  system("#{executable} proj1.rb #{args} < #{test} > my-output")
  output= `diff my-output #{output_file_name}`

  if (output == "") then
    puts("passed")
  else
    puts("FAILED\n#{output}")
  end

  puts("\n")

  File.unlink("my-output")

}
