#use "filesystem.ml"

let buffer = ref "";;

try
  while true do
    let _ = print_string ": " in
    let line = read_line () in
    try
      let tokens = tokenize (!line) in
      let tree = parse tokens in
        let v = eval expr;; in
   with Not_found -> buffer := (!buffer) ^ line
  done
with End_of_file -> ()
;;
