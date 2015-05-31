#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

let r1 = rational (-6) (-8);;
let r2 = rational (-36) 96;;
let r3 = rational 13 (-10);;
let r4 = rational 35 23;;

println_int (denominator r1);;
println_int (denominator r2);;
println_int (denominator r3);;
println_int (denominator r4);;
