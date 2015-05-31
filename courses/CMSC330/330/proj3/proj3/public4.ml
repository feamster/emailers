#use "part4.ml";;
#load "utilities.cmo";;

open Utilities;;

println_int (standard_rule (0, [0; 0; 0; 0; 0; 0; 0; 0]));;
println_int (standard_rule (1, [0; 0; 0; 0; 0; 0; 0; 0]));;

println_int (standard_rule (0, [0; 1; 0; 1; 0; 1; 0; 0]));;
println_int (standard_rule (1, [0; 1; 0; 1; 0; 1; 0; 0]));;

println_int (standard_rule (0, [0; 1; 0; 1; 0; 1; 1; 0]));;
println_int (standard_rule (1, [0; 1; 0; 1; 0; 1; 1; 0]));;

println_int (standard_rule (0, [1; 1; 1; 1; 1; 1; 1; 1]));;
println_int (standard_rule (1, [1; 1; 1; 1; 1; 1; 1; 1]));;

println_int (standard_rule (0, [0; 1; 0; 1; 0; 0; 0; 0]));;
println_int (standard_rule (1, [0; 1; 0; 1; 0; 0; 0; 0]));;

println_int (standard_rule (0, [0; 1; 0; 0; 0; 0; 0; 0]));;
println_int (standard_rule (1, [0; 1; 0; 0; 0; 0; 0; 0]));;
