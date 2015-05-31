(*

let rec filter predicate = function
    [] -> []
  | h::t -> let rest = filter predicate t in
              if predicate h
                then h::rest
                else rest;;

let rec quicksort = function
    [] -> []
  | pivot::t ->
      let lessthan_pivot = ((>=) pivot) in
        let greaterthanorequal_pivot = ((<) pivot) in
          let firstpart = quicksort (filter lessthan_pivot t) in
            let secondpart = quicksort (filter greaterthanorequal_pivot t) in
              firstpart @ [pivot] @ secondpart;;

*)

(*
let rec all_lessthan element list =
  match list with
     [] -> []
   | h::t -> if (h < element)
               then h::(all_lessthan element t)
             else (all_lessthan element t);;

let rec all_greaterthanorequal element list =
  match list with
     [] -> []
   | h::t -> if (h >= element)
               then h::(all_greaterthanorequal element t)
             else (all_greaterthanorequal element t);;

let rec quicksort list =
  match list with
    [] -> []
  | pivot::t -> (quicksort (all_lessthan pivot t)) @ [pivot] @
                (quicksort (all_greaterthanorequal pivot t));;

*)

(*
let rec split pivot = function
    [] -> ([], [])
  | h::t ->
      let (lt, gt) = split pivot t in
        if h < pivot
          then (h::lt, gt)
          else (lt, h::gt);;

let rec quicksort = function
    [] -> []
  | pivot::t -> let (lt, gt) = split pivot t in
      (quicksort lt) @ [pivot] @ (quicksort gt);;
*)

let rec locate_pivot elem list = match list with
   [] -> [elem]
 | h::t ->
     if elem > h
       then h::(locate_pivot elem t)
       else (locate_pivot elem t)::[h];;
       (*else List.append (locate_pivot elem t) [h];;*)

let rec quicksort list = match list with
   [x] -> [x]
 | h::t -> quicksort (locate_pivot h t);;

quicksort [8; 3; 5; 6; 9; 4; 7; 2; 10; 4; 6; 33; 6];;
quicksort [9; 8; 7; 6; 5; 4];;                
quicksort [4; 5; 6; 7; 8; 9];;
quicksort [3];;
quicksort [4; 3];;
quicksort [3; 4];;
