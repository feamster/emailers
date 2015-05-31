#load "graphics.cma";;
open Graphics;;
#load "utilities.cmo";;
open Utilities;;
#use "part4.ml";;

(* This pattern is composed of three well-known oscillators; the top one is
 * called a traffic light, the one in the middle a toad, and the one on the
 * bottom is a blinker.
 *)

let board =
  (15, 15,
    [[0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]]);;

let secret27_rule ((c:int), (l:int list)) =
  let s = List.fold_left (+) 0 l in
    if c = 0 && s = 3
      then 1
      else
        if c = 1 && (s = 2 || s = 3)
          then 1
          else 0;;

run_n_times board generate secret27_rule 4;;
