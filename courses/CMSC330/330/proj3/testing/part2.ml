let app_pair fn pair = match pair with
 (a,b) -> fn(a),fn(b)

let rec apply_n_times fn n x =
if n < 0 then raise (Failure "n is negative")
else if n = 0 then x
else apply_n_times fn (n-1) (fn x)


let rec apply_to_range fn m n =
        if m > n then raise (Failure "m is greater than n")
        else if m = n then [fn n]
        else fn m ::(apply_to_range fn (m+1) n)

let rec compose list x = match list with
                [] -> x
        | [f] -> f x
        | f::fs -> f (compose fs x)
