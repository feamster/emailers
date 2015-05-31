#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

let r1 = rational (-6) (-8);;
let r2 = rational (-36) 96;;
let r3 = rational 13 (-10);;
let r4 = rational 35 23;;

print_endline (string_of_rational r1);;
print_endline (string_of_rational r2);;
print_endline (string_of_rational r3);;
print_endline (string_of_rational r4);;
