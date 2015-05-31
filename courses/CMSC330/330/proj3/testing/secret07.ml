#use "part1.ml";;  (* note some of the functions in part1.ml are used below *)
#use "part2.ml";;
#load "utilities.cmo";;

open Utilities;;

let triple x = 3 * x;;
let square x = x * x;;

println_int_pair (app_pair double (44, 444));;
println_int_pair (app_pair absolute_value (12, (-25)));;
println_int_pair (app_pair triple ((-5), 6));;
println_int_pair (app_pair square ((-5), 6));;
println_int_pair (app_pair square ((12), 23));;
