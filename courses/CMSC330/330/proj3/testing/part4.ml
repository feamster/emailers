type board = int*int*int list list;;
type rule = int*int list -> int;;
let sample =
        (5, 11,
                [[0;0;0;0;0;1;1;0;0;0;0];
                [0;0;0;0;1;1;0;0;0;0;0];
                [0;0;0;0;0;1;0;0;0;1;0];
                [0;0;0;0;0;0;0;0;0;1;0];
                [0;0;0;0;0;0;0;0;0;1;0]]);;

let rec sum = function [] -> 0 | h::t -> h + (sum t);;

let standard_rule ((cell:int), (adj: int list)) =
        let n = (sum adj) in
                if (cell=0 && n=3) || (cell=1 && (n=2 || n=3))
                then 1
                else 0;;

(* I made rather compressed functions, because it was fun. However, it
may be a little more effort to unravel what they are doing. *)

(* Get xth element of list, returning default if index is out of bounds *)
let rec get default list x = match x, list with
        | -1,_ -> default
        | _,[] -> default
        | _,h::t -> if x=0 then h else get default t (x-1);;
(* Same as above but for two-dimensional lists. *)
let rec get2d default list x y = get default (get [] list y) x;;

(* Get a list of adjacent cells (if index is out of range, cell will be 0) *)
let get_adj brd x y = let g = get2d 0 brd in
        [g (x-1) (y-1); g x    (y-1);
         g (x+1) (y-1); g (x+1) y;
         g (x+1) (y+1); g x    (y+1);
         g (x-1) (y+1); g (x-1) y  ];;

let rec imap' i f = function
        | [] -> []
        | h::t -> (f i h)::(imap' (i+1) f t);;

(* replaces each element in list with (f index element) *)
let imap = imap' 0;;

let rec imap2d' j f = function
        | [] -> []
        | h::t -> (imap (f j) h)::(imap2d' (j+1) f t);;

(* replaces each element in list with (f x-idx y-idx element) *)
let imap2d = imap2d' 0;;

let generate (x,y,brd) rl =
        (x,y, imap2d (fun j i cell -> rl (cell,get_adj brd i j)) brd);;


