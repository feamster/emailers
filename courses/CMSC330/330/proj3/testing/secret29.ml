#load "graphics.cma";;
open Graphics;;
#load "utilities.cmo";;
open Utilities;;
#use "part4.ml";;

(* These two symmetrical patterns start out by approaching each other from
 * opposite corners, interacting briefly, then dying out in the 46th
 * generation.
 *)

let board =
  (15, 15,
    [[1; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 1; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 1; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 1]]);;

let secret29_rule ((c:int), (l:int list)) =
  let s = List.fold_left (+) 0 l in
    if c = 0 && s >= 3 && s <= 8
      then 1
      else
        if c = 1 && (s = 2 || s == 3)
          then 1
          else 0;;

run_n_times board generate secret29_rule 48;;
