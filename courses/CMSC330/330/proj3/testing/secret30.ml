#load "graphics.cma";;
open Graphics;;
#load "utilities.cmo";;
open Utilities;;
#use "part4.ml";;

(* A series of nice symmetrical patterns that apparently go on indefinitely;
 * we are only running it for 20 generations here.
 *)

let board =
  (15, 15,
    [[0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
     [1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1];
     [0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
     [1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1];
     [0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
     [1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1];
     [0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
     [1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1];
     [0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
     [1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1];
     [0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
     [1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1];
     [0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
     [1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1];
     [0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0]]);;

let secret30_rule ((c:int), (l:int list)) =
  let s = List.fold_left (+) 0 l in
    if c = 0 && s >= 2 && s <= 8
      then 1
      else
        if c = 1 && (s = 2 || s == 3)
          then 1
          else 0;;

run_n_times board generate secret30_rule 20;;
