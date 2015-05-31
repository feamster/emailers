module type RATIONAL =
  sig
    type t

    val rational : int -> int -> t
    val string_of_rational : t -> string
    val numerator : t -> int
    val denominator : t -> int
    val greaterthan : t -> t -> bool
    val multiply : t -> t -> t
    val add : t -> t -> t
    val ceiling : t -> int
  end

module Rational : RATIONAL =
  struct

    type t = int * int

    let absolute_value x = if (x < 0) then -x else x

    let gcd u v =
      let u2 = abs u
        in let v2 = abs v in
          let rec gcd' u v =
            if v = 0 then u else gcd' v (u mod v)
          in gcd' u2 v2

    let reduce (x, y) =
      if x < 0 && y < 0 || y < 0
        then let g = gcd (-x) (-y) in ((-x)/g, (-y)/g)
        else let g = gcd x y in (x/g, y/g)
      (*
      (*
      if (x < 0 && y < 0) || (y < 0)
        then let x2= -x in let y2= -y in
          let g = gcd x2 y2 in (x2/g, y2/g)
        else let g = gcd x y in (x/g, y/g)
      *)
     (*
      if (x < 0 && y < 0)
        then let x2= (-x) in let y2= (-y) in
          let g = gcd x2 y2 in (x2/g, y2/g)
        else 
      if y < 0
        then let x2= (-x) in let y2= (-y) in
          let g = gcd x2 y2 in (x2/g, y2/g)
   else *)
   let g = gcd x y in (x/g, y/g)
         *)

    let rational x y = (x, y)
     (*
     if x < 0 && y < 0 || y < 0
       then reduce (-x, -y)
       else reduce (x, y)
        *)

    let string_of_rational (x, y) = 
      let (x2, y2) = reduce (x, y) in
        (string_of_int x2) ^ "/" ^ (string_of_int y2)
								
    let numerator (x, y) = let (x2, _) = reduce (x, y) in x2
    let denominator (x, y) = let (_, y2) = reduce (x, y) in y2

    let greaterthan (a, b) (c, d) = (float_of_int a) /. (float_of_int b) >
                                    (float_of_int c) /. (float_of_int d)

    let multiply (a, b) (c, d) = reduce (a * c, b * d)

    let add (a, b) (c, d) = reduce (a * d + c * b, b * d)

    let ceiling (a, b) = if b = 0
                           then 0
                           else (a / b) +
                             if (a > 0 && b > 0) || (a < 0 && b < 0)
                               then (if a mod b = 0 then 0 else 1)
                               else 0 (*(if a mod b = 0 then 0 else 1)*)
  end
