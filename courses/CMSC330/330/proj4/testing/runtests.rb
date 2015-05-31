#!/usr/bin/ruby

result= 1

# the backquote version fails if there aren't any files named secret??.ml
#`ls public?.ml secret??.ml`.split().sort().each() { |test|
Dir["public?.input", "secret??.input"].sort().each() { |test|

  puts("#{test}\n")
  test.length().times().each() {
    print('=')
  }
  puts("")

  test_basename= test.split('.')[0]
  output_file_name= "#{test_basename}.output"

  if (test_basename =~ /(public1|secret0[1-6])/) then
    executable= "scanner"
  else
    if (test_basename =~ /(public2|secret0[7-9])/) then
      executable= "parser"
    else executable= "interpreter"
    end
  end

  system("#{executable} #{test_basename}.input < #{test} > my-output")
  output= `diff my-output #{output_file_name}`

  if (output == "") then
    puts("passed")
  else
    puts("FAILED\n#{output}")
    result= nil
  end

  puts("\n")

  File.unlink("my-output")

}

puts("")
if (result != nil) then
  puts("PASSED")
else puts("FAILED")
end
