open Scanner
open Parser
(*#load "str.cma";;*)

type value =
    Val_Num of int
  | Val_Bool of bool
  | Val_String of string
  | Val_Nil
  | Val_Cons of value * value
  (* You may extend this type, but do not change any of the constructors
     we have given you *)
  | Val_Prim of (value list -> value)
  | Val_Closure of env * (env * value -> value)

and env = (string * value) list

(* The following function may come in handy *)
let rec string_of_value = function
    Val_Num n -> string_of_int n
  | Val_Bool true -> "#t"
  | Val_Bool false -> "#f"
  | Val_String s -> "\"" ^ s ^ "\""
  | Val_Nil -> "nil"
  | Val_Cons (v1, v2) -> "(" ^ (string_of_value v1) ^ " " ^
      (string_of_value v2) ^ ")"
  | Val_Prim _ -> "#<primitive>"
  | Val_Closure _ -> "#<function>"

(* Write your evaluator here *)
let eval _ = Val_Nil


(**
 **
 **  Evaluation
 **
 *)

exception Eval_error of string

(** Primitives **)

let prim_plus l =
  let accum n = function
      Val_Num m -> n + m
    | _ -> raise (Eval_error("``+'' applied to non-numeric argument")) in
  Val_Num (List.fold_left accum 0 l)

let prim_minus = function
  | [Val_Num a] -> Val_Num (-a)
  | ((Val_Num a)::xs) -> begin
      let accum n = function
          Val_Num m -> n - m
        | _ -> raise (Eval_error("``-'' applied to non-numeric argument")) in
      Val_Num (List.fold_left accum a xs)
    end
  | (_::xs) -> raise (Eval_error("``-'' applied to non-numeric argument"))
  | _ -> raise (Eval_error("``-'' applied to wrong number of arguments"))

let prim_times l =
  let accum n = function
      Val_Num m -> n * m
    | _ -> raise (Eval_error("``*'' applied to non-numeric argument")) in
  Val_Num (List.fold_left accum 1 l)

let prim_divide = function
  | [Val_Num a] -> Val_Num a
  | ((Val_Num a)::xs) -> begin
      let accum n = function
          Val_Num m -> n / m
        | _ -> raise (Eval_error("``/'' applied to non-numeric argument")) in
      Val_Num (List.fold_left accum a xs)
    end
  | (_::xs) -> raise (Eval_error("``/'' applied to non-numeric argument"))
  | _ -> raise (Eval_error("``/'' applied to wrong number of arguments"))

let prim_eq = function
    [a; b] -> Val_Bool (a = b)
  | _ -> raise (Eval_error("``='' applied to wrong number of arguments"))

let prim_noteq = function
    [a; b] -> Val_Bool (a <> b)
  | _ -> raise (Eval_error("``<>'' applied to wrong number of arguments"))

let prim_lessthan = function
    [a; b] -> Val_Bool (a < b)
  | _ -> raise (Eval_error("``<'' applied to wrong number of arguments"))

let prim_lessthanequals = function
    [a; b] -> Val_Bool (a <= b)
  | _ -> raise (Eval_error("``<='' applied to wrong number of arguments"))

let prim_greaterthan = function
    [a; b] -> Val_Bool (a > b)
  | _ -> raise (Eval_error("``>'' applied to wrong number of arguments"))

let prim_greaterthanequals = function
    [a; b] -> Val_Bool (a >= b)
  | _ -> raise (Eval_error("``>='' applied to wrong number of arguments"))

let prim_boolp = function
    [Val_Bool b] -> Val_Bool true
  | [_] -> Val_Bool false
  | _ -> raise (Eval_error("``bool?'' applied to wrong number of arguments"))

let prim_numberp = function
    [Val_Num n] -> Val_Bool true
  | [_] -> Val_Bool false
  | _ -> raise (Eval_error("``number?'' applied to wrong number of arguments"))

let prim_stringp = function
    [Val_String s] -> Val_Bool true
  | [_] -> Val_Bool false
  | _ -> raise (Eval_error("``string?'' applied to wrong number of arguments"))

let prim_listp = function
    [Val_Nil] -> Val_Bool true
  | [_] -> Val_Bool false
  | _ -> raise (Eval_error("``list?'' applied to wrong number of arguments"))

let toplev = ref [
  ("nil", Val_Nil);
  ("+", Val_Prim prim_plus);
  ("-", Val_Prim prim_minus);
  ("*", Val_Prim prim_times);
  ("/", Val_Prim prim_divide);
  ("=", Val_Prim prim_eq);
  ("<>", Val_Prim prim_noteq);
  ("<", Val_Prim prim_lessthan);
  ("<=", Val_Prim prim_lessthanequals);
  (">", Val_Prim prim_greaterthan);
  (">=", Val_Prim prim_greaterthanequals);
  ("boolean?", Val_Prim prim_boolp);
  ("number?", Val_Prim prim_numberp);
  ("string?", Val_Prim prim_stringp);
  ("list?", Val_Prim prim_listp);
]

(** Evaluation function **)

let rec eval' e = function
    Id x -> begin
      try
        List.assoc x e
      with Not_found -> List.assoc x (!toplev)
    end
  | Num n -> Val_Num n
  | Bool b -> Val_Bool b
  | String s -> Val_String s
  | List (Id "define"::l) ->
      begin
        match l with
          [Id name; t] ->
            let v  = eval' e t in
            toplev := ((name, v)::(!toplev));
            (* Val_Nil *) v
        | _ -> raise (Eval_error("define applied to wrong number of arguments"))
      end
  | List (Id "lambda"::l) ->
      begin
        match l with
          [List [Id param]; body] ->
            let apply (e', arg) = eval' ((param, arg)::e') body in
            Val_Closure (e, apply)
        | _ -> raise (Eval_error("lambda applied to wrong number of arguments"))
      end
  | List (Id "cons"::l) ->
      begin
        match l with
          [a; b] ->
            let a' = eval' e a in
              let b' = eval' e b in
                Val_Cons (a', b')
        | _ -> raise (Eval_error("cons applied to wrong number of arguments"))
      end
  (*
  | List (Id "car"::l) ->
      begin
        match l with
           [
        let a' = eval' e a in a'
            (*
        match l with
          a::t ->
            let a' = eval' e a in
              match a' with h::t -> h
        | _ -> raise (Eval_error("cons applied to wrong number of arguments"))
               *)
      end
  *)
  | List (Id "if"::l) ->
      begin
        match l with
          [guard; thn; els] ->
            begin
              match eval' e guard with
                Val_Bool true -> eval' e thn
              | Val_Bool false -> eval' e els
              | _ -> raise (Eval_error("if applied to non-boolean guard"))
            end
          | [guard; thn] ->
            begin
              match eval' e guard with
                Val_Bool true -> eval' e thn
              | Val_Bool false -> Val_Nil
              | _ -> raise (Eval_error("if applied to non-boolean guard"))
            end
        | _ -> raise (Eval_error("if applied to wrong number of arguments"))
      end
  | List l ->
      let l' = List.map (eval' e) l in
      match l' with
        [] -> raise (Eval_error("missing or extra expression"))
      | (Val_Prim p::args) -> p args
      | [Val_Closure (e', f); arg] -> f (e', arg)
      | _ -> raise (Eval_error("internal error"))

let eval t = eval' [] t;;

(* Here is a sample main.ml file that uses your lexer, parser, and
   evaluator to read in lines of Scheme and evaluate them.  It reads
   until it sees ;;, concatenating all the lines together, and then
   feeds that to your code. As a bonus, it discards any comments
   beginning with ; *)

(*#use "scheme.ml"*)

(*
let buffer = ref "";;

try
  while true do
    let _ = print_string "Scheme> " in
    let line = read_line () in
    try
      let i = String.index line ';' in
      let _ = buffer := (!buffer) ^ (String.sub line 0 i) in
      if String.length line >= (i+2) && line.[(i+1)] = ';' then
        let tokens = tokenize (!buffer) in
        let tree = parse tokens in
        let v = eval tree in
        begin
          print_endline (string_of_value v);
          buffer := ""
        end
   with Not_found -> buffer := (!buffer) ^ line
  done
with End_of_file -> ()
;;

*)

