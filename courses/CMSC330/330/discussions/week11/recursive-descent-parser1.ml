(*
 * RIGHT-RECURSIVE expression grammar:
 *
 * S -> T + S | T - S | T
 * T -> U * T | U / T | U
 * U -> (S) | V
 * V -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8  9
 *
 * (Note- the program only handles single-digit, nonnegative numbers;
 *  exercise for the interested reader would be to allow multidigit
 *  and negative numbers.)
 *)

exception InvalidExpression of string;;

(*
 * returns the position of the next nonblank character in the string s
 * starting at or after the i'th position, or the length of the string if
 * there is no such character
 *)
let rec next_nonblank_char i s =
  if i >= String.length s
    then i
    else
      let ch = (String.get s i) in
        if ch == ' ' || ch == '\t' || ch == '\n'
          then next_nonblank_char (i + 1) s
          else i;;

(*
 * converts a string of characters into a list of the characters, ignoring
 * whitespace in the string (using the function above)
 *)
let string_to_list s =
  let rec string_to_list' s idx =
    if idx = String.length s
      then []
      else
        let pos = next_nonblank_char idx s in
          (String.get s pos)::(string_to_list' s (pos + 1))
  in string_to_list' s 0;;

let match_terminal lr c =
  match !lr with
     [] -> raise (InvalidExpression ("Expecting " ^ (Char.escaped c) ^
                                     " but found end of expression."))
   | (h::t) ->
       if h = c
         then lr := t
         else raise (InvalidExpression ("Expecting " ^ (Char.escaped c) ^
                                        " but found " ^ (Char.escaped h)));;

let parseV lr =
  match !lr with
     (h::t) when h >= '0' && h <= '9' ->
       lr := t
   | _ -> raise (InvalidExpression "Expected digit was not found.");;

let rec parseU lr =
  match !lr with
     [] -> raise (InvalidExpression "parseU() was called with an empty list")
   | ('('::t) ->
       lr := t;
       let x = parseS lr in
         match_terminal lr ')';
         x
   | _ -> parseV lr

and

parseT lr =
  let x = parseU lr in
    match !lr with
     | ('*'::t) ->
         lr := t; parseT lr
     | ('/'::t) ->
         lr := t; parseT lr
     | _ -> x

and

parseS lr =
  let x = parseT lr in
    match !lr with
     | ('+'::t) ->
         lr := t ; parseS lr
     | ('-'::t) ->
         lr := t ; parseS lr
     | _ -> x;;

let parse_expr s =
  let lr = ref (string_to_list s) in  (* "lr" == "list ref" *)
    let _ = parseS lr in
      if !lr = []
        then print_endline "Valid expression!"
        else raise
             (InvalidExpression ("Expression was not completely consumed " ^
                                 "(probably syntactically invalid)."));;
