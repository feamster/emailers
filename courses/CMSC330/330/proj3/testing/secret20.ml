#load "graphics.cma";;
open Graphics;;
#load "utilities.cmo";;
open Utilities;;
#use "part4.ml";;

(* Uses a nonstandard rule, as do the remaining tests of Life.  With this
 * rule a creature is born if an empty cell has one neighbor, and a
 * creature stays alive if it has exactly three neighbors.  Given this rule
 * and the board size, the pattern dies out in the eighth generation.
 *)

let board =
  (15, 15,
    [[0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]]);;

let secret20_rule ((c:int), (l:int list)) =
  let s = List.fold_left (+) 0 l in
    if c = 0 && s = 1
      then 1
      else
        if c = 1 && s = 3
          then 1
          else 0;;

run_n_times board generate secret20_rule 9;;
