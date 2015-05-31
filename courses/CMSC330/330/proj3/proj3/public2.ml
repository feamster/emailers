#use "part1.ml";;  (* note some of the functions in part1.ml are used below *)
#use "part2.ml";;
#load "utilities.cmo";;

open Utilities;;

println_int_list (addpairs [(1,16); (9,4); (5,6)]);;
println_int_pair (app_pair double (44, 444));;
println_int      (apply_n_times double 10 2);;
println_int_list (apply_to_range double 200 205);;
let subtract1 =  (fun x -> x - 1);;
println_int      (compose
                    [double; subtract1; double; absolute_value] (-4));;
