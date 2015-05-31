let double x = x+x;;

let absolute_value x = if x >= 0 then x else -x;;

let rec power_of_2 x =
        if x <= 0 then raise (Failure "negative input")
        else if x = 1 then true
        else if (x mod 2) = 0 && power_of_2 (x/2) then true
        else false

let rec chebyshev' (x, y, z, k) =
        if k = 2 then 2 * y - z
        else chebyshev'(x, (2 * y - z), y, k-1)

let chebyshev x k =
        if k < 0 then raise (Failure "Undefined for negative k")
        else if k = 0 then 1
        else if k = 1 then x
        else chebyshev' (x, x,1, k) (* 2 *.chebyshev (x, k -1) - chebyshev (x, k -2) *)

let rec chebyshev_ori x k =
        if k < 0 then raise (Failure "Undefined for negative k")
        else if k = 0 then 1
        else if k = 1 then x
        else 2 *(chebyshev_ori x (k-1)) - (chebyshev x (k -2))

let rec product l = match l with
          [] -> 1
        | (x:: xs) -> x * (product xs)

let rec dotproduct l1 l2 = match (l1,l2) with
  ([],[]) -> 0
| ([],y::ys) -> raise(Failure "Inconsistent length")
| (x::xs,[]) -> raise(Failure "Inconsistent length")
| (x::xs, y::ys) -> (x*y) + (dotproduct xs ys)

let rec remove_first x list = match list with
          [] -> []
        | (y::ys) -> if y = x then ys else y::(remove_first x ys)

let rec smallest l = match l with
          [] -> raise (Failure "empty list")
        | [x] -> x
        | x::y -> if x < (smallest y) then x else (smallest y)

let rec selection_sort l = match l with
          [] -> []
        | [x] -> [x]
        | x::y ->
                if x < smallest(y) then x::(selection_sort y)
                else smallest(y)::(selection_sort(x::(remove_first (smallest l) y)))

let rec string_of_int_list_helper l = match l with
          [] -> ""
        | [x] -> string_of_int x
        | x::xs -> string_of_int (x)^ "; " ^ string_of_int_list_helper (xs)

let rec string_of_int_list l = match l with
          [] -> "[]"
        | x -> "[" ^ string_of_int_list_helper(x) ^ "]"

let rec addpairs l = match l with
          [] -> []
        | ((a, b):: t) -> (a + b) :: addpairs(t)

let rec flat l1 l2 = match l1 with
          [] -> l2
        | (h::t) -> h::(flat t l2);;

let rec flatten l = match l with
          [] -> []
        | (h::t) -> flat h (flatten t);;
