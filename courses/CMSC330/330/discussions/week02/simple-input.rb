#!/usr/local/bin/ruby -w

puts("This is a simple Ruby program.")
puts("Please enter a string:")

str= gets()
str= str.chomp()  # chomp() is here to remove the newline (how could we write
                  # this without an assignment?)

print("You entered: ", str, ".\n")

# if you like to do a lot in one line, then try:
# print("You entered ", gets.chomp(), ".\n")
