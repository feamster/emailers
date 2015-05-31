#use "part1.ml";;
#load "utilities.cmo";;

open Utilities;;

println_int_list     (flatten [[]]);;
println_int_list     (flatten [[1; 2; 3]; []; [4; 5]]);;
println_int_list     (flatten [[9; 3]; [8; 4; 7; 2]; [5; 6]]);;
println_int_list     (flatten [[3; -3]; [-8; 4]; [7; 5; -5; 6]]);;
