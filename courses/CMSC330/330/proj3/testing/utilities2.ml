type board = int  *  int  *  int list list;;

let sample_board =
  (5, 11,
    [[0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0];
     [0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0];
     [0; 0; 0; 0; 0; 1; 0; 0; 0; 1; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0];
     [0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0]]);;

let rec draw_big x y n v =
  begin
    if n = 0 then
      begin
        Graphics.set_color Graphics.white;
        Graphics.fill_circle ((x + 6) * 10) ((800) - ((y + 10) * 10)) 10;
        Graphics.set_color Graphics.black;
        Graphics.draw_circle ((x + 6) * 10) ((800) - ((y + 10) * 10)) 10
      end
    else
      begin
        Graphics.set_color Graphics.black;
        Graphics.fill_circle ((x + 6) * 10) ((800) - ((y + 10) * 10)) 10
      end
  end;;

(*
let rec draw_big x y n =
  begin
    if n = 0 then
      begin
        Graphics.set_color Graphics.white;
        Graphics.fill_circle ((x+10)*10) ((y+10)*10) 5;
        Graphics.set_color Graphics.black;
        Graphics.draw_circle ((x+10)*10) ((y+10)*10) 5
      end
    else
      begin
        Graphics.set_color Graphics.black;
        Graphics.fill_circle ((x+10)*10) ((y+10)*10) 5
      end
  end
*)

let draw_game ((_:int), (vert:int), (ll:int list list)) =
  let rec draw_line x y = function
      [] -> ()
    | (n::xs) -> (draw_big x y n vert;
                  draw_line (x + 3) y xs) in
  let rec draw_game' x y = function
      [] -> ()
    | (l::ls) -> (draw_line x y l;
                  draw_game' x (y + 3) ls) in
  (*draw_game' 0 0 ll;*)
  draw_game' 0 0 ll;
  Graphics.synchronize ();;

(*
let draw_game ((_:int), (_:int), (ll:int list list)) =
  let rec draw_line x y = function
      [] -> ()
    | (n::xs) -> (draw_big x y n;
                  draw_line (x+1) y xs) in
  let rec draw_game' x y = function
      [] -> ()
    | (l::ls) -> (draw_line x y l; draw_game' x (y+1) ls) in
  draw_game' 0 0 ll;
  Graphics.synchronize ()
*)

let run_graphical b generate rule =
  match b with (h, v, ll) ->
  let rec run_graphical' c n =
    draw_game c;
    (*
    Graphics.moveto 185 10;
    (* clear previous line *)
    Graphics.draw_string "                                ";
    Graphics.synchronize ();
    *)
    (* clear previous line *)
    Graphics.set_color Graphics.white;
    Graphics.fill_rect 185 10 180 20;
    Graphics.set_color Graphics.black;
    Graphics.moveto 185 10;
    Graphics.draw_string ("Generation #" ^ (string_of_int n));
    Graphics.synchronize ();
  (* let _ = read_line () in *)
  (* Unix.sleep 2; *)
  let _ = Graphics.wait_next_event [Graphics.Key_pressed] in
  (* it would be nice to test the key and go back a generation if it's a
     backspace *)
  (* let key = Graphics.read_key () in *)
    run_graphical' (generate c rule) (n + 1) in
  (*Graphics.open_graph " 750x750";*)
  (*
    print_string ((String.make 1 '"') ^ " " ^
                             (string_of_int (h * 35)) ^ "x" ^
                             (string_of_int (v * 40)) ^ (String.make 1 '"') ^
                  "\n");
   *)
    (*
  Graphics.open_graph ((String.make 1 '"') ^ " " ^
                             (string_of_int (h * 35)) ^ "x" ^
                             (string_of_int (v * 40)) ^ (String.make 1 '"'));
       *)
  Graphics.open_graph " 750x750";
  Graphics.auto_synchronize false;
  Graphics.set_text_size 100;
  Graphics.set_font "10x20";
  (* Graphics.clear_graph (); *)
  (* Graphics.set_text_size 1000; *)
  run_graphical' b 0;;

(* let _ = run_graphical sample_board;; *)
