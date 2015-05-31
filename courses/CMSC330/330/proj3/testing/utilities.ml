open Graphics;;

let println_int x = print_endline (string_of_int x);;

let println_bool x = print_endline (string_of_bool x);;

let println_int_pair (a, b) = print_endline ("(" ^ (string_of_int a) ^ ", " ^
                          (string_of_int b) ^ ")");;

(**)
let string_of_int_list l =
    let rec string_of_int_elements l = match l with
          [] -> ""
        | (h::[]) -> string_of_int h
        | (h::t) -> string_of_int h ^ "; " ^ string_of_int_elements t
    in "[" ^ string_of_int_elements l ^ "]";;
(**)

let println_int_list l = print_endline (string_of_int_list l);;

let string_of_char_list l =
    let rec string_of_char_elements l = match l with
          [] -> ""
        | (h::[]) -> "'" ^ String.make 1 h ^ "'"
        | (h::t) -> "'" ^ String.make 1 h ^ "'; " ^ string_of_char_elements t
    in "[" ^ string_of_char_elements l ^ "]";;

let println_char_list l = print_endline (string_of_char_list l);;


let print_game (max_y, max_x, ll) =
  let rec print_line = function
      [] -> print_char '\n'
    | (x::xs) -> (print_int x; print_line xs) in
  let rec print_game' =
    function
        [] -> ()
      | (l::ls) -> (print_line l; print_game' ls) in
  print_game' ll;;

type board = int  *  int  *  int list list;;

let sample_board =
  (5, 11,
    [[0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0];
     [0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 1; 0; 0; 0; 1; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0]]);;

let run b generate rule =
  let rec run' b n =
    print_game b;
    print_string "\n";
    print_string ("Generation #" ^ (string_of_int n) ^ "\n\n\n");
    let _ = read_line () in
      run' (generate b rule) (n + 1)
    in run' b 0;;

let run_n_times b generate rule n =
  if (n < 0)
    then raise (Failure "Undefined for negative executions")  (* lah *)
    else
      let rec run_n_times' b i =
        if (i = 0)
          then
            begin
              print_game b;
              print_string "\n";
              print_string ("Generation #" ^ (string_of_int n) ^ "\n");
            end
          else run_n_times' (generate b rule) (i - 1)
      in run_n_times' b n;;

let oth_rule ((c:int), (l:int list)) =
  let s = List.fold_left (+) 0 l in
    if c = 0 && s = 3
      then 1
      else
        if c = 0 && s = 2
          then 1
          else 0

