#use "part1.ml";;
#load "utilities.cmo";;

open Utilities;;

println_int       (double 330);;
println_int       (absolute_value (-330));;
println_bool      (power_of_2 1048576);;
println_bool      (power_of_2 1048575);;
println_int       (product [3; 1; 4; 1; 5; 6]);;
println_int       (dotproduct [3; 1; 4; 1; 5; 6] [2; 3; 0; 2; 5; 8]);;
println_char_list (remove_first 'h' ['c'; 'h'; 'a'; 't']);;
println_int       (smallest [9; 3; 8; 4; 7; 2; 5; 6]);;
println_int_list  (selection_sort [9; 3; 8; 4; 7; 2; 5; 6]);;
println_int_list  (selection_sort [1; 1; 1; 1; 1; 1; 1; 1]);;
print_endline     (string_of_int_list [9; 3; 8; 4; 7; 2; 5; 6]);;
