let val_xy x y (max_y, max_x, ll) =
  let rec val'_x x l =
    if x = 0 then List.hd l
    else val'_x (x - 1) (List.tl l) in
  let rec val'_xy x y ll =
    if y = 0 then val'_x x (List.hd ll)
    else val'_xy x (y - 1) (List.tl ll) in
  if x < 0 || x >= max_x || y < 0 || y >= max_y then 0
  else val'_xy x y ll

let rec adj x y b =
  (val_xy x y b,
   [val_xy (x - 1) (y - 1) b;
   val_xy (x - 1) y b;
   val_xy (x - 1) (y + 1) b;
   val_xy x (y - 1) b;
   val_xy x (y + 1) b;
   val_xy (x + 1) (y - 1) b;
   val_xy (x + 1) y b;
   val_xy (x + 1) (y + 1) b])

let generate_cell b r x y = r (adj x y b)

let rec generate_x b r x y =
  let (_, max_x, _) = b in
  if x = max_x
    then []
    else (generate_cell b r x y)::(generate_x b r (x + 1) y)

let rec generate_y b r y =
  let (max_y, _, _) = b in
    if y = max_y
      then []
      else (generate_x b r 0 y)::(generate_y b r (y + 1))

let generate b r =
  let (max_y, max_x, _) = b in
    (max_y, max_x, generate_y b r 0)

let standard_rule ((c:int), (l:int list)) =
  let s = List.fold_left (+) 0 l in
    if s = 3
      then 1
      else
        if c = 1 && s = 2
          then 1
          else 0
