let rec last = function
  [x] -> x
| h::t -> last t;;

(* uses two higher-order functions *)
(*
let product_of_lasts l =
  List.fold_left ( * ) 1 (List.map last l);;
*)

(* doesn't use any higher-order functions *)
(*
let rec product_of_lasts l =
  match l with
      [x] -> last x
    | h::t -> (last h) * (product_of_lasts t);;
*)

(* uses just one higher-order function *)
(*
let rec multiply = function
    [] -> 1
  | h::t -> h * (multiply t);;

let product_of_lasts l =
  multiply (List.map last l);;
*)

(* also uses just one higher-order function *)

let rec get_last_elements = function
    [] -> []  (* note the base case can't be [x] -> (last x) *)
  | h::t -> (last h)::(get_last_elements t);;

let product_of_lasts l =
  List.fold_left ( * ) 1 (get_last_elements l);;

let println_int x = print_endline (string_of_int x);;

print_endline "";;
println_int (product_of_lasts [[330]]);;
println_int (product_of_lasts [[1; 2; 3]]);;
println_int (product_of_lasts [[1; 2; 3]; [4; 5; 6]]);;
println_int (product_of_lasts [[2; 3]; [4; 5; 6]; [7]]);;
println_int (product_of_lasts [[2]; [4]; [6]; [8]]);;
