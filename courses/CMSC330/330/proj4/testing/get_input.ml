let buffer = ref "";;

let rec get_input () =
  print_string "> " ;
  let line = read_line () in
    try
      let i = String.index line ';' in
        if String.length line >= (i + 2) && line.[i + 1] = ';'
          then
            let trimmed = (String.sub line 0 (String.length line - 2)) in
              let temp = (!buffer) ^ trimmed in
                buffer := "" ; temp
          else ""
    with Not_found -> buffer := (!buffer) ^ " " ^ line ; get_input ()

(*
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
          Printf.printf "%s evaluates to %s\n" (unparse tree) (string_of_value v);
          buffer := ""
        end
   with Not_found -> buffer := (!buffer) ^ line
  done
with End_of_file -> ();;
*)
