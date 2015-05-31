#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

let r1 = rational 1 7;;
let r2 = rational 2 7;;
let r3 = rational 1 4;;
let r4 = rational (-1) 4;;

print_endline (string_of_rational (add r1 r2));;
print_endline (string_of_rational (add r1 r3));;
print_endline (string_of_rational (add r3 r3));;
print_endline (string_of_rational (add r3 r4));;
