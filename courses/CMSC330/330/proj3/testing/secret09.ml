#use "part1.ml";;  (* note some of the functions in part1.ml are used below *)
#use "part2.ml";;
#load "utilities.cmo";;

open Utilities;;

let triple x = 3 * x;;
let square x = x * x;;

println_int_list (apply_to_range double 10 25);;
println_int_list (apply_to_range double 10 10);;

println_int_list (apply_to_range triple 1 15);;
println_int_list (apply_to_range square 1 15);;
println_int_list (apply_to_range absolute_value (-15) (-1));;
