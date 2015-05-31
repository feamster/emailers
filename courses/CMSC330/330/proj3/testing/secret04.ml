#use "part1.ml";;
#load "utilities.cmo";;

open Utilities;;

println_int       (smallest [9]);;
println_int       (smallest [1; 1; 1; 1; 1; 1; 1]);;
println_int       (smallest [-4; -5; -7; -6; -2; -3; -1]);;
println_int       (smallest [9; 3; 8; 4; 7; 2; 5; 6; 1; 10; 1]);;
