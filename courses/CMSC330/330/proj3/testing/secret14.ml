#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

let r1 = rational 3 5;;
let r2 = rational 4 5;;
let r3 = rational 3 5;;

let r4 = rational (-6) 8;;
let r5 = rational (-36) 46;;
let r6 = rational 6 (-8);;

print_endline (string_of_bool (greaterthan r1 r2));;
print_endline (string_of_bool (greaterthan r1 r3));;

print_endline (string_of_bool (greaterthan r4 r5));;
print_endline (string_of_bool (greaterthan r4 r6));;

print_endline (string_of_bool (greaterthan r1 r4));;
print_endline (string_of_bool (greaterthan r4 r1));;
