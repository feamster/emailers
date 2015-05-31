#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

let r1 = rational 3 5;;
let r2 = rational 4 5;;
let r3 = rational 5 3;;

let r4 = rational (-6) 8;;
let r5 = rational 8 (-6);;

print_endline (string_of_rational (multiply r1 r2));;
print_endline (string_of_rational (multiply r1 r3));;
print_endline (string_of_rational (multiply r2 r3));;
print_endline (string_of_rational (multiply r4 r5));;
