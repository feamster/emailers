open Get_input
open Scanner

let rec scan () =
  try
    let line = get_input () in
      let tokens = tokenize line in
        print_endline (string_of_string_list tokens) ; scan ()
  with End_of_file -> ();;

scan ();;
