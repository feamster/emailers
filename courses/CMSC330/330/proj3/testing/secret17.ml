#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

let r1 = rational 1 2;;
let r2 = rational (-1) 2;;
let r3 = rational 10 2;;
let r4 = rational (-10) 2;;

println_int (ceiling r1);;
println_int (ceiling r2);;
println_int (ceiling r3);;
println_int (ceiling r4);;
