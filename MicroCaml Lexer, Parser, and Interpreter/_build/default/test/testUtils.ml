open OUnit2
open P4.Types
open P4.Lexer
open P4.Parser
open P4.Eval
open P4.Utils

type run_test_mode = Parser | Eval

(* Assertion wrappers for convenience and readability *)
let assert_true b = assert_equal true b
let assert_false b = assert_equal false b
let assert_succeed () = assert_true true

let file_to_string file =
  let ch = open_in file in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let get_file fname = file_to_string ("data/" ^ fname)
let string_to_tokens s = tokenize s
let gen_ast_parse_expr file = get_file file |> tokenize |> parse_expr
let gen_ast_parse_mutop file = get_file file |> tokenize |> parse_mutop

let get_expr ast =
  let _, e = ast in
  e

let eval_expr_ast env ast =
  let e = ast |> get_expr in
  eval_expr env e

let eval_mutop_ast env ast =
  let e = ast |> get_expr in
  eval_mutop env e

let input_handler f =
  try
    let _ = f () in
    assert_failure "Expected InvalidInputException, none received"
  with
  | InvalidInputException _ -> assert_succeed ()
  | ex ->
      assert_failure
        ("Got " ^ Printexc.to_string ex ^ ", expected InvalidInputException")

let div_by_zero_ex_handler f =
  try
    let _ = f () in
    assert_failure "Expected DivByZeroError, none received"
  with
  | DivByZeroError -> assert_succeed ()
  | ex ->
      assert_failure
        ("Got " ^ Printexc.to_string ex ^ ", expected DivByZeroError")

let declare_error_ex_handler f =
  try
    let _ = f () in
    assert_failure "Expected DeclareError, none received"
  with
  | DeclareError _ -> assert_succeed ()
  | ex ->
      assert_failure ("Got " ^ Printexc.to_string ex ^ ", expected DeclareError")

let type_error_ex_handler f =
  try
    let _ = f () in
    assert_failure "Expected TypeError, none received"
  with
  | TypeError _ -> assert_succeed ()
  | ex ->
      assert_failure ("Got " ^ Printexc.to_string ex ^ ", expected TypeError")

let rec lookup env x =
  match env with
  | [] -> raise (DeclareError ("Unbound variable " ^ x))
  | (var, value) :: t -> if x = var then !value else lookup t x

let string_of_toks_expr (_, ast) = string_of_expr ast

let string_of_toks_mutop (_, ast) = string_of_mutop ast

let string_of_eval_mutop (env, expr) =
  let env_str = string_of_list (fun (x, e) -> x ^ (string_of_expr !e)) env in
  let expr_str = match expr with 
  | None -> "None" 
  | Some(e) -> string_of_expr e in
  env_str ^ " " ^ expr_str

let run_test_expr ~mode (input, our_parse, our_eval) _ =
  match mode with
  | Parser ->
      let student = input |> tokenize |> parse_expr in
      assert_equal student our_parse
        ~msg:
          ("parser error:\nexpected: "
          ^ string_of_toks_expr our_parse
          ^ "\nstudent:  "
          ^ string_of_toks_expr student)
  | Eval ->
      let student = input |> tokenize |> parse_expr |> eval_expr_ast [] in
      assert_equal student our_eval
        ~msg:
          ("eval error:\nexpected: " ^ string_of_expr our_eval ^ "\nstudent:  "
         ^ string_of_expr student)

let run_test_eval ~mode (input, our_parse, our_eval) _ =
  match mode with
  | Parser ->
      let student = input |> tokenize |> parse_mutop in
      assert_equal student our_parse
        ~msg:
          ("parser error:\nexpected: "
          ^ string_of_toks_mutop our_parse
          ^ "\nstudent:  "
          ^ string_of_toks_mutop student)
  | Eval ->
      let student = input |> tokenize |> parse_mutop |> eval_mutop_ast [] in
      assert_equal student our_eval
        ~msg:
          ("eval error:\nexpected: "
          ^ string_of_eval_mutop our_eval
          ^ "\nstudent:  "
          ^ string_of_eval_mutop student)
