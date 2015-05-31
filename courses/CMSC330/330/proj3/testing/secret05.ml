#use "part1.ml";;
#load "utilities.cmo";;

open Utilities;;

println_int_list  (selection_sort []);;
println_int_list  (selection_sort [1]);;
println_int_list  (selection_sort [2; 2; 2; 2; 2; 2; 2; 2]);;
println_int_list  (selection_sort [9; 3; 8; 10; 7; 2; 5; 6; 4; 1]);;
println_int_list  (selection_sort [1; 3; 8; 5; 6; 4; 1; 10; 7; 2; 12; 11]);;
println_int_list  (selection_sort
                   [1; 3; 8; 0; 5; 6; -4; 1; 10; -7; 2; -12; 11]);;
