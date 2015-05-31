#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

let r1 = rational 6 8;;
let r2 = rational 36 96;;
let r3 = rational 13 10;;

print_endline (string_of_rational r1);;

println_int (numerator r2);;
println_int (denominator r2);;

print_endline (string_of_bool (greaterthan r1 r2));;
print_endline (string_of_bool (greaterthan r2 r1));;
print_endline (string_of_bool (greaterthan r3 r1));;

print_endline (string_of_rational (multiply r1 r3));;
print_endline (string_of_rational (multiply r2 r3));;

println_int (ceiling r1);;
println_int (ceiling r3);;
