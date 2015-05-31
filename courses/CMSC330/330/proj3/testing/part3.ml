module type RATIONAL =
sig
        type t
    val rational : int -> int -> t (* num -> den -> rat *)
    val string_of_rational : t -> string (* num/den, reduced *)
    val numerator : t -> int (* numerator *)
    val denominator : t -> int (* denominator *)
    val greaterthan : t -> t -> bool (* true if 1st arg > 2nd arg *)
    val multiply : t -> t -> t (* multiplication *)
    val add : t -> t -> t (* addition *)
    val ceiling : t -> int (* ceiling *)
end

module Rational: RATIONAL =
        struct
                type t = int*int

                let rational a b = (a,b)

                let abs x = if (x<0) then -x else x

          let rec gcd' x y =
                        if y = 0 then x
                        else gcd' y (x mod y)

                let gcd a b =
                                gcd' (abs a) (abs b)

                let reduce (a,b) =
                        if a < 0 && b < 0 || b < 0 then
                                ((-a)/(gcd (-a) (-b)), (-b)/(gcd (-a) (-b)))
                        else
                                (a/(gcd a b), b/(gcd a b))

                let string_of_rational (a, b) =
                        let (aa, bb) = reduce(a, b) in
                                (string_of_int aa)^ "/" ^(string_of_int bb)

                let numerator (a, b) = let (aa, _) = reduce (a, b) in aa

                let denominator (a, b) = let (_, bb) = reduce(a, b) in bb

                let greaterthan (a,b) (c,d) = if (a*d - b*c > 0 && b*d > 0) || (a*d - b*c < 0 && b*d < 0) then true else false

                let multiply(a,b) (c,d) = reduce(a*c, b*d)

                let add (a,b) (c,d) = reduce(a*d+b*c, b*d)

                let ceiling (a,b) =
                        if b = 0 then 0
                        else (a/b) +
                                if (a>0 && b>0) || (a<0 && b<0) then
                                        begin
                                                if a mod b = 0 then 0
                                                else 1
                                        end
                                else 0
end