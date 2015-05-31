#use "part1.ml";;
#use "part2.ml";;
#use "part3.ml";;
#load "utilities.cmo";;

open Utilities;;
open Rational;;

try
  println_bool  (power_of_2 (-1));
  print_endline "Expected exception was not raised."
with Failure _ -> print_endline "Expected exception was raised.";;

try
  println_int 	(dotproduct [1; 2; 3] [4; 5]);
  print_endline "Expected exception was not raised."
with Failure _ -> print_endline "Expected exception was raised.";;

try
  println_int   (chebyshev (-2) (-2));
  print_endline "Expected exception was not raised."
with Failure _ -> print_endline "Expected exception was raised.";;
