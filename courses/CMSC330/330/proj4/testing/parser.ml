(**
 **
 **  Parsing
 **
 **)

(* Use this as your abstract syntax tree *)
type ast =
    Id of string
  | Num of int
  | Bool of bool
  | String of string
  | List of ast list

let rec parse_list l =
  match l with (h::t) ->
  if h = ")" then
    (t, [])
  else
    let (t', s) = parse_sexpr (h::t) in
    let (t'', l) = parse_list t' in
    (t'', s :: l)
    | _ -> raise (Failure "bad parse") (*[] -> ([], [])*)  (* lah not sure *)

and parse_sexpr l =
  match l with
      [] -> raise (Failure "empty list")
      (* print_endline "here" ; ([], Bool false)  (* lah not sure *) *)
   | (h::t) ->
  if h = "(" then
    let (rest, l) = parse_list t in
    (rest, List l)
  else if h = "#t" then
    (t, Bool true)
  else if h = "#f" then
    (t, Bool false)
  else if h.[0] = '"' then
      (t, String (String.sub h 1 ((String.length h) - 2)))
  else
    try
      (t, Num (int_of_string h))
    with Failure _ -> (t, Id h)

let parse l =
  (*let (_, a) = parse_sexpr (l @ ["$"]) in a*)
  let (rest, a) = parse_sexpr l in
    match rest with
     [] -> a
     | _ -> raise (Failure "did not consume expression")

(* An unparser turns an AST back into a string.  You may find this
   unparser handy in writing this project *)
let rec unparse_list = function
    [] -> ""
  | (x::[]) -> unparse x
  | (x::xs) -> (unparse x) ^ " " ^ (unparse_list xs)

and unparse = function
  | Id id -> id
  | Num n -> string_of_int n
  | Bool true -> "#t"
  | Bool false -> "#f"
  | String s -> "\"" ^ s ^ "\""
  | List l -> "(" ^ unparse_list l ^ ")"

(*
let buffer = ref "";;

try
  while true do
    let line = read_line () in
    let _ = buffer := (!buffer) ^ line in
    try
	let tokens = tokenize (!buffer) in
        try
  	  let _ = parse tokens in
          print_endline "Valid" ; buffer := ""
        with Failure _ -> print_endline "Invalid."  ; buffer := ""
        (*print_endline (unparse tree) ; buffer := ""*)
   with Not_found -> buffer := (!buffer) ^ line
  done
with End_of_file -> ()
;;
*)
