
let rec app_pair f p =
  match p with
     (x, y) -> (f x), (f y)

let rec apply_n_times f n x =
  if n < 0
    then raise (Failure "Undefined for empty list")  (* lah *)
    else
      if n = 0
        then x
        else apply_n_times f (n - 1) (f x)

let rec apply_to_range f m n =
  if m > n
    then raise (Failure "Undefined for empty list")  (* lah *)
  else
    if m = n
      then [f m]
      else f(m)::apply_to_range f (m + 1) n

(* note right to left *)
let rec compose l x = match l with
    [] -> x
  | [f] -> f x
  | h::t -> h (compose t x)
