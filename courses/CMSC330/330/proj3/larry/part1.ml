let double x = 2 * x

let absolute_value x = if (x < 0) then -x else x

let rec power_of_2 = function
    1 -> true
  | x -> (x mod 2 = 0) && (power_of_2 (x / 2))

let rec chebyshev' x y z = function
    0 -> z
  | 1 -> y
  | k -> chebyshev' x ((2 * y) - z) y (k - 1)

let chebyshev x k =
  if k < 0
    then raise (Failure "Undefined for negative k")  (* lah *)
    else chebyshev' x x 1 k

let rec cheb x k =
    if k = 0
      then 1
      else
        if k = 1
          then x
          else
            let a = cheb (k - 1) x in
              let b = cheb (k - 2) x in
                2 * a - b

let rec product = function
    [] -> 1
  | x::xs -> x * (product xs)

let rec dotproduct l1 l2 =
  match (l1, l2) with
      ([], []) -> 0
    | (x::xs, []) -> raise (Failure "Undefined for empty list")  (* lah *)
    | ([], x::xs) -> raise (Failure "Undefined for empty list")  (* lah *)
    | (x::xs, y::ys) -> (x * y) + (dotproduct xs ys)

let rec remove_first ch l = match l with
    [] -> []
  | y::ys -> if (ch = y) then ys else y::(remove_first ch ys)

let rec smallest = function
    [] -> raise (Failure "Undefined for empty list")  (* lah *)
  | [x] -> x
  | x::xs ->
      begin
        let y = smallest xs in
          if x < y then x else y
      end

let rec selection_sort = function
    [] -> []
  | [x] -> [x]
  | x::xs ->
      begin
        let y = smallest xs in
        if x < y then
          x::(selection_sort xs)
        else
          y::(selection_sort (x::(remove_first y xs)))
      end

let rec string_of_int_list' = function
    [] -> ""
  | [i] -> string_of_int i
  | i::is -> (string_of_int i) ^ "; " ^ (string_of_int_list' is)

let string_of_int_list = function
    [] -> "[]"
  | xs -> "[" ^ (string_of_int_list' xs) ^ "]"

(*
let largest = function
    [] -> raise (Failure "Undefined for empty list")  (* lah *)
  | [x] -> x
  | x::xs -> List.fold_left max x xs
*)

let rec addpairs = function
    [] -> []
  | ((x, y)::t) -> (x + y)::addpairs(t)

let rec flatten = function
    [] -> []
  | (h::t1)::t2 -> h::(flatten (t1::t2))
  | []::t2 -> flatten t2
