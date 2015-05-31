type entry =
    Nil
  | File of string * entry
  | Directory of string * bool * entry

(*
let compare_names elt1 elt2 =
  match (elt1, elt2) with
     (File(n1), File(n2)) -> n1 > n2
   | (File(n1), Directory(n2, _, _)) -> n1 > n2
   | (Directory(n1, _, _), File(n2)) -> n1 > n2
   | (Directory(n1, _, _), Directory(n2, _, _)) -> n1 > n2

let get_name = (function (File(name)) -> name |
                (Directory(name, _, _)) -> name)

let rec insert e fs = match fs with
   [] -> [e]
 | (h::t) ->
     let name1 = get_name e in
       let name2 = get_name h in
         if (name1 = name2)
           then t
           else
             if compare_names e h
               then h::insert e t
               else e::h::t
*)

let filesystem () = (Directory("/", true, Nil))

(*
let touch filesystem filename =
  match filesystem with (directory_name, subdirs, cwd) ->
    (directory_name, (insert (File(filename)) subdirs), cwd);;

let mkdir filesystem dirname =
  match filesystem with (directory_name, subdirs, cwd) ->
    (directory_name, (insert (Directory(dirname, [], false)) subdirs), cwd);;
*)

(*
(* we assume there is always some current directory *)
let rec find filesystem name =
  match filesystem with (directory_name, contents, cwd) ->
    if cwd = true
        then filesystem
        else find' contents name
and
let rec find' list name =
  match list with
     (File(_))::t -> find name t
   | (Directory(name2, contents, true))::t ->
       (Directory(name2, contents, true))
   | (Directory(name2, contents, false))::t ->
       if find' t name
*)

(**
let rec print_files = (function list ->
  match list with
     [] -> ()
   | h::t ->
       match h with
          File(name) -> print_string (name ^ "\n") ; print_files t
        | Directory(name, _, _) ->
            print_string (name ^ "/\n") ; print_files t);;

let ls filesystem =
  match filesystem with (directory_name, contents, cwd) ->
    print_files contents;;

let rec cd' list directory =
  match list with
     [] -> []  (* should never occur *)
   | (File(_))::t -> cd' t directory
   | (Directory(dname, contents, _))::t ->
       if directory = dname
           then (Directory(directory, contents, true))::t
           else (Directory(dname, contents, false))::(cd' t directory)

let rec cd filesystem directory =
  match filesystem with (directory_name, contents, cwd) ->
    (directory_name, (cd' contents directory), false)

(*
    match contents with
       (File(f))::t -> (directory_name, (File(f))::(cd t directory), false)
     | (Directory(name, list, cwd2))::t ->
         if directory = name
             then (Directory(name, list, true))::t
             else (Directory(name, list, cwd2))::(cd t directory)
*)

let rec touch filesystem filename =
  match filesystem with
     (directory_name, subdirs, true) ->
       (directory_name, (insert (File(filename)) subdirs), true)
   | (directory_name, subdirs, false) ->
       match subdirs with
          [] -> filesystem ()  (* should never occur *)
        | (File(f))::t -> (directory_name, ((File(f))::
       (directory_name, (touch , false)

let mkdir filesystem dirname =
  match filesystem with (directory_name, subdirs, cwd) ->
    (directory_name, (insert (Directory(dirname, [], false)) subdirs), cwd);;

*)

let rec insert list filename =
  match list with
     Nil -> File(filename, Nil)
   | (File(name, rest)) ->
       if name < filename
           then (File(name, (insert rest filename)))
           else (File(filename, (File(name, rest))))
   | (Directory(name, flag, rest)) ->
       if name < filename
           then (Directory(name, flag, (insert rest filename)))
           else (File(filename, (Directory(name, flag, rest))))

let rec insert_dir list filename =
  match list with
     Nil -> Directory(filename, false, Nil)
   | (File(name, rest)) ->
       if name < filename
           then (Directory(name, false, (insert_dir rest filename)))
           else (Directory(filename, false, (File(name, rest))))
   | (Directory(name, flag, rest)) ->
       if name < filename
           then (Directory(name, flag, (insert_dir rest filename)))
           else (Directory(filename, flag, (Directory(name, flag, rest))))

let rec touch filesystem filename =
  match filesystem with
     Nil -> raise (Failure "should not occur")
   | (File(name, rest)) -> raise (Failure "should not occur")
   | (Directory(directory_name, cwd, Nil)) ->
       (Directory(directory_name, cwd, (File(filename, Nil))))
   (*| list -> insert list filename*)
   | (Directory(directory_name, cwd, rest)) ->
       (Directory(directory_name, cwd, (insert rest filename)))

let rec mkdir filesystem dirname =
  match filesystem with
     Nil -> raise (Failure "should not occur")
   | (File(name, rest)) -> raise (Failure "should not occur")
   | (Directory(directory_name, cwd, Nil)) ->
       (Directory(directory_name, cwd, (Directory(dirname, false, Nil))))
   (*| list -> insert list filename*)
   | (Directory(directory_name, cwd, rest)) ->
       (Directory(directory_name, cwd, (insert_dir rest dirname)))

let rec ls filesystem =
  match filesystem with
     Nil -> print_string "\n"
   | (File(name, Nil)) -> print_endline name
   | (File(name, rest)) -> print_endline name ; ls rest
(*
   | (Directory(directory_name, cwd, Nil)) ->
       (*print_string (directory_name ^ "/\n") *)
       print_endline ""
*)
   | (Directory(directory_name, cwd, rest)) ->
       (*print_string (directory_name ^ "/\n") ;*) ls rest

let f = filesystem ()
let f = touch f "cherry"
let f = touch f "kiwi"
let f = touch f "banana"
let f = touch f "grape"
let f = mkdir f "apple"
let f = touch f "banana"
let f = mkdir f "fig"
let f = touch f "date"
let f = touch f "pear"
let f = mkdir f "lemon"
