#use "part1.ml";;  (* note some of the functions in part1.ml are used below *)
#use "part2.ml";;
#load "utilities.cmo";;

open Utilities;;

let triple x = 3 * x;;
let square x = x * x;;
let subtract1 =  (fun x -> x - 1);;

println_int      (compose [double; subtract1; square; absolute_value; triple]
                          (-4));;
println_int      (compose [absolute_value; double; triple; subtract1; square]
                          (-5));;
println_int      (compose [square; subtract1; absolute_value; triple; double]
                          (-8));;
println_int      (compose [subtract1; square; triple; double; absolute_value]
                          (-8));;
println_int      (compose [triple; square; double; absolute_value; subtract1]
                          (-8));;
