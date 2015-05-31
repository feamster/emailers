#use "part1.ml";;  (* note some of the functions in part1.ml are used below *)
#use "part2.ml";;
#load "utilities.cmo";;

open Utilities;;

let triple x = 3 * x;;
let square x = x * x;;

println_int      (apply_n_times double 17 4);;
println_int      (apply_n_times triple 10 3);;
println_int      (apply_n_times square 3 5);;
println_int      (apply_n_times absolute_value 2 (-10));;
