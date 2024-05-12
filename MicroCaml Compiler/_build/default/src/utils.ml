open Ast

let parse_expr s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.token lexbuf in
  ast

let string_of_list ?(newline = false) (f : 'a -> string) (l : 'a list) : string
    =
  "["
  ^ (String.concat ", " @@ List.map f l)
  ^ "]"
  ^ if newline then "\n" else ""

let string_of_expr (e : expr) : string = show_expr e

(**********************************
 * BEGIN ACTUAL PARSE HELPER CODE *
 **********************************)

let string_of_in_channel (ic : in_channel) : string =
  let lines : string list =
    let try_read () =
      try Some (input_line ic ^ "\n") with End_of_file -> None
    in
    let rec loop acc =
      match try_read () with Some s -> loop (s :: acc) | None -> List.rev acc
    in
    loop []
  in

  List.fold_left (fun a e -> a ^ e) "" @@ lines

let rec string_of_type t =
  match t with
  | TInt -> "int"
  | TBool -> "bool"
  | TArrow (t1, t2) -> "(" ^ string_of_type t1 ^ "->" ^ string_of_type t2 ^ ")"
  | TRec lst ->
      "{"
      ^ List.fold_left
          (fun acc (Lab l, t) -> l ^ ":" ^ string_of_type t ^ "; " ^ acc)
          "" lst
      ^ "}"
  | TBottom -> "null"
